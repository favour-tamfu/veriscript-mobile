import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import {
  decodeBase64,
  encodeBase64,
} from 'https://deno.land/std@0.224.0/encoding/base64.ts'
import { corsHeaders } from '../_shared/cors.ts'
import { supabaseAdmin } from '../_shared/supabase_admin.ts'
import { getAccessToken, loadServiceAccount } from '../_shared/google_auth.ts'

// Layout-preserving document translation via Google Cloud Translation v3.
//
// Flow (fully synchronous — no webhook): the client uploads the source file to
// the `documents` bucket and calls this function with the storage path. We pull
// the bytes, translate the whole document with Google v3 (which keeps fonts,
// tables and images), and drop the translated file into the `processed` bucket.
// The client then downloads it with a signed URL, exactly like the converter.
//
// Document translation is NOT available in the `global` location — a regional
// endpoint is required. us-central1 supports it.
const LOCATION = Deno.env.get('GOOGLE_TRANSLATE_LOCATION') ?? 'us-central1'

const DOC_MIME_TYPES: Record<string, string> = {
  pdf: 'application/pdf',
  docx: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  pptx: 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  xlsx: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
}

function extOf(fileName: string): string {
  const dot = fileName.lastIndexOf('.')
  return dot === -1 ? '' : fileName.slice(dot + 1).toLowerCase()
}

function translatedName(fileName: string, targetLang: string): string {
  const dot = fileName.lastIndexOf('.')
  const stem = dot === -1 ? fileName : fileName.slice(0, dot)
  const ext = dot === -1 ? '' : fileName.slice(dot)
  return `${stem}-${targetLang}${ext}`
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { storagePath, sourceLang, targetLang, userId, fileName } = await req
      .json()

    if (!storagePath || !targetLang || !userId || !fileName) {
      return new Response(
        JSON.stringify({ error: 'Missing required fields' }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        },
      )
    }

    const ext = extOf(fileName)
    const isPlainText = ext === 'txt'
    const docMimeType = DOC_MIME_TYPES[ext]

    if (!isPlainText && !docMimeType) {
      return new Response(
        JSON.stringify({
          error:
            `Unsupported document type ".${ext}". Supported: PDF, DOCX, PPTX, XLSX, TXT.`,
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        },
      )
    }

    // 1. Pull the source bytes from the `documents` bucket.
    const { data: blob, error: downloadError } = await supabaseAdmin.storage
      .from('documents')
      .download(storagePath)

    if (downloadError || !blob) {
      throw new Error(`Failed to download source: ${downloadError?.message}`)
    }
    const sourceBytes = new Uint8Array(await blob.arrayBuffer())

    // 2. Authenticate with Google.
    const account = loadServiceAccount()
    const accessToken = await getAccessToken(account)
    const parent = `projects/${account.project_id}/locations/${LOCATION}`
    const baseUrl = `https://translation.googleapis.com/v3/${parent}`

    let outputBytes: Uint8Array
    let outputContentType: string
    let detectedSourceLang: string | null = null

    if (isPlainText) {
      // 3a. Plain text isn't a "document" to the API — translate the text and
      // write a new .txt. Decoded with explicit fatal:false so odd bytes don't
      // throw.
      const text = new TextDecoder('utf-8', { fatal: false }).decode(sourceBytes)
      const body: Record<string, unknown> = {
        contents: [text],
        targetLanguageCode: targetLang,
        mimeType: 'text/plain',
      }
      if (sourceLang && sourceLang !== 'auto') {
        body.sourceLanguageCode = sourceLang
      }

      const resp = await fetch(`${baseUrl}:translateText`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
      })
      if (!resp.ok) {
        throw new Error(`Google translateText failed: ${await resp.text()}`)
      }
      const data = await resp.json()
      const translation = data.translations?.[0]
      outputBytes = new TextEncoder().encode(translation?.translatedText ?? '')
      outputContentType = 'text/plain'
      detectedSourceLang = translation?.detectedLanguageCode ?? null
    } else {
      // 3b. Real document translation — layout preserved.
      const body: Record<string, unknown> = {
        targetLanguageCode: targetLang,
        documentInputConfig: {
          content: encodeBase64(sourceBytes),
          mimeType: docMimeType,
        },
      }
      if (sourceLang && sourceLang !== 'auto') {
        body.sourceLanguageCode = sourceLang
      }

      const resp = await fetch(`${baseUrl}:translateDocument`, {
        method: 'POST',
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
      })
      if (!resp.ok) {
        throw new Error(`Google translateDocument failed: ${await resp.text()}`)
      }
      const data = await resp.json()
      const docTranslation = data.documentTranslation
      const b64 = docTranslation?.byteStreamOutputs?.[0]
      if (!b64) {
        throw new Error('Google returned no translated document.')
      }
      outputBytes = decodeBase64(b64)
      outputContentType = docTranslation.mimeType ?? docMimeType
      detectedSourceLang = docTranslation.detectedLanguageCode ?? null
    }

    // 4. Store the translated file in the `processed` bucket.
    const outName = translatedName(fileName, targetLang)
    const outputPath = `${userId}/${Date.now()}-${outName}`
    const { error: uploadError } = await supabaseAdmin.storage
      .from('processed')
      .upload(outputPath, outputBytes, {
        contentType: outputContentType,
        upsert: true,
      })
    if (uploadError) {
      throw new Error(`Failed to store translated file: ${uploadError.message}`)
    }

    // 5. Best-effort usage record (document translation is billed per page by
    // Google; this only marks activity, it does not meter exact characters).
    // Non-fatal: the translated file is already stored, so a quota hiccup must
    // not turn a successful translation into an error for the user.
    try {
      await supabaseAdmin.rpc('increment_chars_translated', {
        p_user_id: userId,
        p_chars: 0,
      }).maybeSingle()
    } catch (quotaError) {
      console.error('translate-document quota update failed:', quotaError)
    }

    return new Response(
      JSON.stringify({
        outputPath,
        outputName: outName,
        detectedSourceLang,
        mimeType: outputContentType,
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    )
  } catch (error) {
    console.error('translate-document error:', error)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
