import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { corsHeaders } from '../_shared/cors.ts'
import { supabaseAdmin } from '../_shared/supabase_admin.ts'

// Verifies CloudConvert's `CloudConvert-Signature` header (HMAC-SHA256 of the
// raw request body, signed with the webhook's signing secret).
async function isValidSignature(
  secret: string,
  payload: string,
  signature: string,
): Promise<boolean> {
  const key = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign'],
  )
  const sigBuffer = await crypto.subtle.sign(
    'HMAC',
    key,
    new TextEncoder().encode(payload),
  )
  const computed = Array.from(new Uint8Array(sigBuffer))
    .map((b) => b.toString(16).padStart(2, '0'))
    .join('')
  return computed === signature
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const raw = await req.text()

    // If a signing secret is configured and CloudConvert sent a signature,
    // reject the request unless it verifies. (No header => signing not enabled
    // on the webhook, so we let it through.)
    const webhookSecret = Deno.env.get('CLOUDCONVERT_WEBHOOK_SECRET')
    const signature = req.headers.get('CloudConvert-Signature')
    if (webhookSecret && signature) {
      const valid = await isValidSignature(webhookSecret, raw, signature)
      if (!valid) {
        return new Response(JSON.stringify({ error: 'Invalid signature' }), {
          status: 401,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })
      }
    }

    const body = JSON.parse(raw)
    const { job } = body

    if (!job) {
      return new Response(JSON.stringify({ error: 'Missing job' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const { id: cloudConvertJobId, status, tag: supabaseJobId, tasks } = job

    if (!supabaseJobId) {
      return new Response(JSON.stringify({ received: true }), {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    if (status === 'finished') {
      // Find export task
      const exportTask = tasks?.find((t: any) => t.operation === 'export/url')
      const fileUrl = exportTask?.result?.files?.[0]?.url

      if (!fileUrl) {
        await supabaseAdmin
          .from('conversion_jobs')
          .update({ status: 'failed' })
          .eq('id', supabaseJobId)
        return new Response(JSON.stringify({ error: 'No output file URL' }), {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })
      }

      // Get job details to determine userId and output format
      const { data: job } = await supabaseAdmin
        .from('conversion_jobs')
        .select('*')
        .eq('id', supabaseJobId)
        .single()

      if (!job) throw new Error('Job not found')

      // Download the converted file
      const fileResponse = await fetch(fileUrl)
      if (!fileResponse.ok) throw new Error('Failed to download converted file')

      const fileBuffer = await fileResponse.arrayBuffer()
      const outputPath = `${job.user_id}/${supabaseJobId}.${job.to_format}`

      // Upload to Supabase Storage processed bucket
      const { error: uploadError } = await supabaseAdmin.storage
        .from('processed')
        .upload(outputPath, fileBuffer, {
          contentType: `application/${job.to_format}`,
          upsert: true,
        })

      if (uploadError) throw uploadError

      await supabaseAdmin
        .from('conversion_jobs')
        .update({ status: 'done', output_path: outputPath })
        .eq('id', supabaseJobId)
    } else if (status === 'error') {
      await supabaseAdmin
        .from('conversion_jobs')
        .update({ status: 'failed' })
        .eq('id', supabaseJobId)
    }

    return new Response(JSON.stringify({ received: true }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (error) {
    console.error('cloudconvert-webhook error:', error)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
