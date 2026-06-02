import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { corsHeaders } from '../_shared/cors.ts'
import { supabaseAdmin } from '../_shared/supabase_admin.ts'

// Copyleaks calls the per-scan status webhook configured at submit time:
//   /functions/v1/copyleaks-webhook/{STATUS}/<scanId>
// {STATUS} is substituted by Copyleaks (e.g. "completed", "error"). The scanId
// is a literal segment we add so it's available deterministically. We still
// fall back to the request body for older in-flight scans.
//
// Important: the payload carries a numeric `status` (e.g. 1) even on FAILED
// scans, and an `error` object when something went wrong (e.g. insufficient
// credits). So the error case must take precedence over any "status === 1"
// heuristic, and completion is determined by the URL path status.
serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const url = new URL(req.url)
    const segments = url.pathname.split('/').filter(Boolean)
    const fnIndex = segments.indexOf('copyleaks-webhook')
    const pathStatus = fnIndex >= 0 ? segments[fnIndex + 1] : undefined
    const pathScanId = fnIndex >= 0 ? segments[fnIndex + 2] : undefined

    const raw = await req.text()
    let body: any = {}
    try {
      body = raw ? JSON.parse(raw) : {}
    } catch (_) {
      body = {}
    }

    const scanId = pathScanId ?? body?.scannedDocument?.scanId ?? body?.scanId
    const statusWord = (pathStatus ?? '').toString().toLowerCase()

    if (!scanId) {
      console.error('copyleaks-webhook: no scanId', url.pathname, raw.slice(0, 500))
      return new Response(JSON.stringify({ error: 'Missing scanId' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const hasError =
      body?.error != null || statusWord === 'error' || statusWord === 'failed'
    const isCompleted = !hasError &&
      (statusWord === 'completed' ||
        statusWord === 'success' ||
        statusWord === 'finished')

    if (hasError) {
      await supabaseAdmin
        .from('scan_reports')
        .update({
          status: 'failed',
          error_message: body?.error?.message ?? 'Scan failed.',
        })
        .eq('external_scan_id', scanId)
    } else if (isCompleted) {
      const results = body?.results ?? {}
      const similarityPct = results?.score?.aggregatedScore ?? 0

      const rawSources = [
        ...(results?.internet ?? []),
        ...(results?.database ?? []),
        ...(results?.batch ?? []),
        ...(results?.repositories ?? []),
        ...(results?.comparison ?? []),
      ]
      const sources = rawSources.map((s: any) => ({
        url: s.url ?? s.metadata?.finalUrl ?? '',
        title: s.title ?? s.url ?? 'Unknown Source',
        matchedPercent: s.matchedPercent ?? 0,
        matchedWords: s.matchedWords ?? s.totalWords ?? 0,
      }))

      // AI content detection (enabled via aiGeneratedText.detect at submit).
      // Copyleaks adds a 'suspected-ai-text' alert when AI is detected; its
      // additionalData carries { summary: { ai, human } } as 0-1 floats. We
      // store a 0-100 percentage. No alert => detection ran but found none.
      let aiProbability = 0
      const alerts = body?.notifications?.alerts ?? body?.alerts ?? []
      const aiAlert = Array.isArray(alerts)
        ? alerts.find((a: any) =>
            a?.code === 'suspected-ai-text' || a?.alertId === 'suspected-ai-text')
        : undefined
      if (aiAlert) {
        let extra: any = aiAlert.additionalData
        if (typeof extra === 'string') {
          try { extra = JSON.parse(extra) } catch (_) { extra = {} }
        }
        const aiScore = extra?.summary?.ai ?? results?.ai?.summary?.ai
        aiProbability = typeof aiScore === 'number' ? Math.round(aiScore * 100) : 100
      }

      await supabaseAdmin
        .from('scan_reports')
        .update({
          status: 'done',
          similarity_pct: similarityPct,
          ai_probability: aiProbability,
          sources: JSON.stringify(sources),
        })
        .eq('external_scan_id', scanId)
    }
    // Non-terminal lifecycle events (new, indexed, creditsChecked, …) are acked.

    return new Response(JSON.stringify({ received: true }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (error) {
    console.error('copyleaks-webhook error:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
