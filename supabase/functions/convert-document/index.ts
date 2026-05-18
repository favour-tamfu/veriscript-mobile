import { createClient } from 'jsr:@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

Deno.serve(async (request) => {
  if (request.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  if (request.method !== 'POST') {
    return json({ error: 'Method not allowed' }, 405)
  }

  const authorization = request.headers.get('Authorization')
  if (!authorization) {
    return json({ error: 'Missing Authorization header' }, 401)
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL') ?? '',
    Deno.env.get('SUPABASE_ANON_KEY') ?? '',
    {
      global: {
        headers: {
          Authorization: authorization,
        },
      },
    },
  )

  const {
    data: { user },
    error: userError,
  } = await supabase.auth.getUser()

  if (userError || !user) {
    return json({ error: 'Unauthorized' }, 401)
  }

  const form = await request.formData()
  const file = form.get('file')
  const targetFormat = String(form.get('targetFormat') ?? '').toLowerCase()

  if (!(file instanceof File) || !targetFormat) {
    return json({ error: 'file and targetFormat are required' }, 400)
  }

  const safeName = file.name.replace(/[^a-zA-Z0-9._-]/g, '_')
  const objectPath = `${user.id}/${crypto.randomUUID()}-${safeName}`

  const { error: uploadError } = await supabase.storage
    .from('documents')
    .upload(objectPath, file, {
      contentType: file.type || 'application/octet-stream',
      upsert: false,
    })

  if (uploadError) {
    return json({ error: uploadError.message }, 500)
  }

  const { data: document, error: documentError } = await supabase
    .from('documents')
    .insert({
      user_id: user.id,
      name: file.name,
      kind: 'conversion',
      source_path: objectPath,
      target_format: targetFormat,
      status: 'queued',
      details: 'Stored in Supabase Storage and waiting for conversion worker.',
    })
    .select('id')
    .single()

  if (documentError) {
    return json({ error: documentError.message }, 500)
  }

  const { error: jobError } = await supabase.from('conversion_jobs').insert({
    user_id: user.id,
    document_id: document.id,
    source_filename: file.name,
    source_object_path: objectPath,
    target_format: targetFormat,
    status: 'queued',
  })

  if (jobError) {
    return json({ error: jobError.message }, 500)
  }

  const { data: signedUrlData, error: signedUrlError } = await supabase.storage
    .from('documents')
    .createSignedUrl(objectPath, 60 * 60)

  if (signedUrlError) {
    return json({ error: signedUrlError.message }, 500)
  }

  return json({
    message: 'File uploaded and queued for conversion.',
    documentId: document.id,
    downloadUrl: signedUrlData.signedUrl,
  })
})

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      'Content-Type': 'application/json',
    },
  })
}
