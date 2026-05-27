import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { corsHeaders } from '../_shared/cors.ts'
import { supabaseAdmin } from '../_shared/supabase_admin.ts'

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const body = await req.json()

    // Copyleaks sends: { scanId, status, results: { score: { aggregatedScore }, comparison: [...sources] } }
    const { scanId, status, results } = body

    if (!scanId) {
      return new Response(JSON.stringify({ error: 'Missing scanId' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    if (status === 'completed' || status === 'success' || status === 'finished') {
      const similarityPct = results?.score?.aggregatedScore ?? 0

      const sources = (results?.comparison ?? []).map((source: any) => ({
        url: source.url ?? '',
        title: source.title ?? source.url ?? 'Unknown Source',
        matchedPercent: source.matchedPercent ?? 0,
        matchedWords: source.matchedWords ?? 0,
      }))

      await supabaseAdmin
        .from('scan_reports')
        .update({
          status: 'done',
          similarity_pct: similarityPct,
          sources: JSON.stringify(sources),
        })
        .eq('external_scan_id', scanId)
    } else if (status === 'error' || status === 'failed') {
      await supabaseAdmin
        .from('scan_reports')
        .update({ status: 'failed' })
        .eq('external_scan_id', scanId)
    }

    return new Response(JSON.stringify({ received: true }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (error) {
    console.error('copyleaks-webhook error:', error)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
