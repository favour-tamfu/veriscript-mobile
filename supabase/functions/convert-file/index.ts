import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { corsHeaders } from '../_shared/cors.ts'
import { supabaseAdmin } from '../_shared/supabase_admin.ts'

// TODO: DEVELOPER ACTION — set CloudConvert webhook URL in CloudConvert Dashboard
// Webhook URL: https://YOUR_PROJECT_REF.supabase.co/functions/v1/cloudconvert-webhook

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { jobId, storagePath, fromFormat, toFormat } = await req.json()

    if (!jobId || !storagePath || !fromFormat || !toFormat) {
      return new Response(JSON.stringify({ error: 'Missing required fields' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // Get signed URL from Supabase Storage
    const { data: signedData, error: signedError } = await supabaseAdmin.storage
      .from('documents')
      .createSignedUrl(storagePath, 3600)

    if (signedError || !signedData?.signedUrl) {
      throw new Error(`Failed to get signed URL: ${signedError?.message}`)
    }

    const cloudConvertKey = Deno.env.get('CLOUDCONVERT_KEY')!
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const projectRef = supabaseUrl.replace('https://', '').replace('.supabase.co', '')

    // Create CloudConvert job
    const ccResponse = await fetch('https://api.cloudconvert.com/v2/jobs', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${cloudConvertKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        tasks: {
          'import-file': {
            operation: 'import/url',
            url: signedData.signedUrl,
          },
          'convert-file': {
            operation: 'convert',
            input: 'import-file',
            input_format: fromFormat,
            output_format: toFormat,
          },
          'export-file': {
            operation: 'export/url',
            input: 'convert-file',
          },
        },
        webhook_url: `https://${projectRef}.supabase.co/functions/v1/cloudconvert-webhook`,
        tag: jobId,
      }),
    })

    if (!ccResponse.ok) {
      const errText = await ccResponse.text()
      throw new Error(`CloudConvert job creation failed: ${errText}`)
    }

    const ccData = await ccResponse.json()
    const cloudConvertJobId = ccData.data?.id

    // Update conversion_jobs with external job ID
    await supabaseAdmin
      .from('conversion_jobs')
      .update({ status: 'processing', external_job_id: cloudConvertJobId })
      .eq('id', jobId)

    return new Response(
      JSON.stringify({ success: true, cloudConvertJobId }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('convert-file error:', error)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
