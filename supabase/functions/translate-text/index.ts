import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { corsHeaders } from '../_shared/cors.ts'
import { supabaseAdmin } from '../_shared/supabase_admin.ts'

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { text, sourceLang, targetLang, userId, documentId } = await req.json()

    if (!text || !targetLang || !userId) {
      return new Response(JSON.stringify({ error: 'Missing required fields' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // Check translations cache
    let cacheQuery = supabaseAdmin
      .from('translations')
      .select('*')
      .eq('user_id', userId)
      .eq('input_text', text)
      .eq('target_lang', targetLang)

    if (sourceLang && sourceLang !== 'auto') {
      cacheQuery = cacheQuery.eq('source_lang', sourceLang)
    }

    const { data: cached } = await cacheQuery.maybeSingle()

    if (cached) {
      return new Response(
        JSON.stringify({
          translatedText: cached.output_text,
          detectedSourceLang: cached.source_lang,
          charCount: text.length,
          fromCache: true,
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Call Google Cloud Translate
    const googleKey = Deno.env.get('GOOGLE_TRANSLATE_KEY')!
    const translateBody: any = {
      q: text,
      target: targetLang,
      format: 'text',
    }
    if (sourceLang && sourceLang !== 'auto') {
      translateBody.source = sourceLang
    }

    const translateResponse = await fetch(
      `https://translation.googleapis.com/language/translate/v2?key=${googleKey}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(translateBody),
      }
    )

    if (!translateResponse.ok) {
      const errText = await translateResponse.text()
      throw new Error(`Google Translate failed: ${errText}`)
    }

    const translateData = await translateResponse.json()
    const translation = translateData.data.translations[0]
    const translatedText = translation.translatedText
    const detectedSourceLang = translation.detectedSourceLanguage ?? sourceLang

    // Cache result
    const id = crypto.randomUUID()
    await supabaseAdmin.from('translations').insert({
      id,
      user_id: userId,
      document_id: documentId ?? null,
      source_lang: detectedSourceLang ?? sourceLang ?? 'auto',
      target_lang: targetLang,
      input_text: text,
      output_text: translatedText,
      created_at: new Date().toISOString(),
    })

    // Update usage quotas
    await supabaseAdmin.rpc('increment_chars_translated', {
      p_user_id: userId,
      p_chars: text.length,
    }).maybeSingle()

    return new Response(
      JSON.stringify({
        translatedText,
        detectedSourceLang,
        charCount: text.length,
        fromCache: false,
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('translate-text error:', error)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
