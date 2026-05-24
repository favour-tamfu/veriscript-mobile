import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const { jobId, storagePath, fromFormat, toFormat } = await req.json()

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  await supabase.from('conversion_jobs').update({ status: 'processing' }).eq('id', jobId)

  await new Promise((resolve) => setTimeout(resolve, 3000))

  await supabase.from('conversion_jobs').update({
    status: 'done',
    output_path: `placeholder/converted_${jobId}.${toFormat}`
  }).eq('id', jobId)

  return new Response(JSON.stringify({ success: true, storagePath, fromFormat }), {
    headers: { 'Content-Type': 'application/json' }
  })
})
