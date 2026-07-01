import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { corsHeaders } from '../_shared/cors.ts'
import { supabaseAdmin } from '../_shared/supabase_admin.ts'

// Quetext API base — all calls go through here.
const QUETEXT_BASE = 'https://www.quetext.com/api'

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { jobId, storagePath, documentId, userId, detectAi } = await req.json()

    if (!jobId || !storagePath || !documentId || !userId) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const queTextKey = Deno.env.get('QUETEXT_API_KEY')
    if (!queTextKey) {
      throw new Error('QUETEXT_API_KEY is not set')
    }

    // ── 1. Mark the report as processing ──────────────────────────────────
    await supabaseAdmin
      .from('scan_reports')
      .update({ status: 'processing' })
      .eq('id', jobId)

    // ── 2. Download the file from Supabase Storage ─────────────────────────
    // We get a short-lived signed URL, then fetch the raw bytes so we can
    // forward them to Quetext as multipart/form-data.
    const { data: signedData, error: signedError } = await supabaseAdmin.storage
      .from('documents')
      .createSignedUrl(storagePath, 300) // 5 minutes is plenty

    if (signedError || !signedData?.signedUrl) {
      throw new Error(`Failed to get signed URL: ${signedError?.message}`)
    }

    const fileResponse = await fetch(signedData.signedUrl)
    if (!fileResponse.ok) {
      throw new Error(`Failed to download file from Storage: ${fileResponse.statusText}`)
    }
    const fileBytes = await fileResponse.arrayBuffer()

    // Derive a filename from the storage path for the multipart upload.
    const fileName = storagePath.split('/').pop() ?? 'document'

    // Infer MIME type from extension; default to application/octet-stream.
    const ext = fileName.split('.').pop()?.toLowerCase() ?? ''
    const mimeMap: Record<string, string> = {
      pdf:  'application/pdf',
      doc:  'application/msword',
      docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      txt:  'text/plain',
    }
    const mimeType = mimeMap[ext] ?? 'application/octet-stream'

    // ── 3. Submit plagiarism report (file-based) ───────────────────────────
    const plagForm = new FormData()
    plagForm.append('file', new Blob([fileBytes], { type: mimeType }), fileName)
    plagForm.append('title', fileName)

    const plagResponse = await fetch(`${QUETEXT_BASE}/v2/report-file`, {
      method: 'POST',
      headers: { 'x-api-key': queTextKey },
      body: plagForm,
    })

    if (!plagResponse.ok) {
      const errText = await plagResponse.text()
      // HTTP 402 = insufficient credits — map to a known error code.
      if (plagResponse.status === 402) {
        await supabaseAdmin
          .from('scan_reports')
          .update({ status: 'failed', error_message: 'insufficient_credits' })
          .eq('id', jobId)
        return new Response(
          JSON.stringify({ error: 'insufficient_credits' }),
          { status: 402, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
      }
      throw new Error(`Quetext plagiarism submit failed (${plagResponse.status}): ${errText}`)
    }

    const plagData = await plagResponse.json()
    if (!plagData?.status || !plagData?.data?.id) {
      throw new Error(`Quetext returned unexpected payload: ${JSON.stringify(plagData)}`)
    }
    const plagReportId: string = plagData.data.id

    // ── 4. Submit AI-detection report (optional, file-based) ───────────────
    let aiReportId: string | null = null
    if (detectAi !== false) {
      const aiForm = new FormData()
      aiForm.append('file', new Blob([fileBytes], { type: mimeType }), fileName)
      aiForm.append('title', fileName)

      const aiResponse = await fetch(`${QUETEXT_BASE}/v2/ai-detect-report-file`, {
        method: 'POST',
        headers: { 'x-api-key': queTextKey },
        body: aiForm,
      })

      if (aiResponse.ok) {
        const aiData = await aiResponse.json()
        if (aiData?.status && aiData?.data?.id) {
          aiReportId = aiData.data.id as string
        } else {
          console.warn('scan-document: Quetext AI report returned unexpected payload', aiData)
        }
      } else {
        // AI detection failing is non-fatal — log and continue.
        // The plagiarism result will still be delivered.
        console.warn(
          'scan-document: Quetext AI detect submit failed',
          aiResponse.status,
          await aiResponse.text()
        )
      }
    }

    // ── 5. Persist report IDs for the poll function ────────────────────────
    // Encoded as a compact JSON string so both IDs fit in the existing
    // external_scan_id text column without a schema change.
    const externalScanId = JSON.stringify({
      provider: 'quetext',
      plagReportId,
      aiReportId,
    })

    await supabaseAdmin
      .from('scan_reports')
      .update({ external_scan_id: externalScanId })
      .eq('id', jobId)

    return new Response(
      JSON.stringify({ success: true, plagReportId, aiReportId }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('scan-document error:', error)

    // Best-effort: mark the scan as failed so the UI doesn't hang.
    try {
      const body = await (async () => {
        try { return await req.clone().json() } catch (_) { return null }
      })()
      if (body?.jobId) {
        await supabaseAdmin
          .from('scan_reports')
          .update({ status: 'failed', error_message: 'scan_error' })
          .eq('id', body.jobId)
      }
    } catch (_) { /* ignore secondary error */ }

    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
