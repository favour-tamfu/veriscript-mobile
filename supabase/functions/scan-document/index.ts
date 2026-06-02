import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { corsHeaders } from '../_shared/cors.ts'
import { supabaseAdmin } from '../_shared/supabase_admin.ts'

// TODO: DEVELOPER ACTION — set Copyleaks webhook URL in Copyleaks Dashboard
// Webhook URL: https://YOUR_PROJECT_REF.supabase.co/functions/v1/copyleaks-webhook

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { jobId, storagePath, documentId, userId } = await req.json()

    if (!jobId || !storagePath || !documentId || !userId) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Update scan_reports status to processing
    await supabaseAdmin
      .from('scan_reports')
      .update({ status: 'processing' })
      .eq('id', jobId)

    // Get signed URL for the file from Supabase Storage
    const { data: signedData, error: signedError } = await supabaseAdmin.storage
      .from('documents')
      .createSignedUrl(storagePath, 3600)

    if (signedError || !signedData?.signedUrl) {
      throw new Error(`Failed to get signed URL: ${signedError?.message}`)
    }

    const signedUrl = signedData.signedUrl

    // Authenticate with Copyleaks
    const copyleaksKey = Deno.env.get('COPYLEAKS_KEY')!
    const copyleaksEmail = Deno.env.get('COPYLEAKS_EMAIL')!
    const loginResponse = await fetch('https://id.copyleaks.com/v3/account/login/api', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: copyleaksEmail, key: copyleaksKey }),
    })

    if (!loginResponse.ok) {
      throw new Error(`Copyleaks login failed: ${loginResponse.statusText}`)
    }

    const loginData = await loginResponse.json()
    const token = loginData.access_token

    // Submit to Copyleaks
    const scanId = crypto.randomUUID().replace(/-/g, '')
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const projectRef = supabaseUrl.replace('https://', '').replace('.supabase.co', '')

    const submitResponse = await fetch(
      `https://api.copyleaks.com/v3/education/submit/url/${scanId}`,
      {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          url: signedUrl,
          properties: {
            // Run AI-generated-content detection in the same scan; the result
            // comes back as a 'suspected-ai-text' alert in the completion webhook.
            aiGeneratedText: {
              detect: true,
            },
            webhooks: {
              // {STATUS} is substituted by Copyleaks; scanId is appended as a
              // literal segment so the webhook can identify the scan reliably.
              status: `https://${projectRef}.supabase.co/functions/v1/copyleaks-webhook/{STATUS}/${scanId}`,
            },
          },
        }),
      }
    )

    if (!submitResponse.ok) {
      const errText = await submitResponse.text()
      throw new Error(`Copyleaks submit failed: ${errText}`)
    }

    // Save external scan ID
    await supabaseAdmin
      .from('scan_reports')
      .update({ external_scan_id: scanId })
      .eq('id', jobId)

    return new Response(
      JSON.stringify({ success: true, scanId }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('scan-document error:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
