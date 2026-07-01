// Service-account OAuth for Google Cloud APIs (used by translate-document).
//
// The Advanced (v3) Translation API — the only tier that can translate a whole
// document and hand back a formatted document — requires an OAuth2 bearer token
// from a service account, not the simple `?key=` used by the v2 text API.
//
// This signs a JWT with the service account's private key (RS256 via Web Crypto)
// and exchanges it for a short-lived access token at Google's token endpoint.

interface ServiceAccount {
  client_email: string
  private_key: string
  project_id: string
  token_uri?: string
}

let cachedToken: { token: string; expiresAt: number } | null = null

function base64UrlEncode(bytes: Uint8Array): string {
  let binary = ''
  for (const b of bytes) binary += String.fromCharCode(b)
  return btoa(binary).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '')
}

function base64UrlEncodeString(str: string): string {
  return base64UrlEncode(new TextEncoder().encode(str))
}

/** Convert a PEM PKCS#8 private key into an importable ArrayBuffer. */
function pemToArrayBuffer(pem: string): ArrayBuffer {
  const body = pem
    .replace(/-----BEGIN PRIVATE KEY-----/, '')
    .replace(/-----END PRIVATE KEY-----/, '')
    .replace(/\s+/g, '')
  const binary = atob(body)
  const buffer = new Uint8Array(binary.length)
  for (let i = 0; i < binary.length; i++) buffer[i] = binary.charCodeAt(i)
  return buffer.buffer
}

export function loadServiceAccount(): ServiceAccount {
  const raw = Deno.env.get('GOOGLE_SERVICE_ACCOUNT_JSON')
  if (!raw) {
    throw new Error(
      'GOOGLE_SERVICE_ACCOUNT_JSON is not set. Document translation needs a ' +
        'Google Cloud service-account JSON with the Cloud Translation API User role.',
    )
  }
  const account = JSON.parse(raw) as ServiceAccount
  if (!account.client_email || !account.private_key || !account.project_id) {
    throw new Error('GOOGLE_SERVICE_ACCOUNT_JSON is missing required fields.')
  }
  return account
}

/** Returns a cached (or freshly minted) OAuth2 access token for the Translation API. */
export async function getAccessToken(account: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  if (cachedToken && cachedToken.expiresAt - 60 > now) {
    return cachedToken.token
  }

  const tokenUri = account.token_uri ?? 'https://oauth2.googleapis.com/token'
  const header = { alg: 'RS256', typ: 'JWT' }
  const claims = {
    iss: account.client_email,
    scope: 'https://www.googleapis.com/auth/cloud-translation',
    aud: tokenUri,
    iat: now,
    exp: now + 3600,
  }

  const signingInput =
    `${base64UrlEncodeString(JSON.stringify(header))}.` +
    `${base64UrlEncodeString(JSON.stringify(claims))}`

  const key = await crypto.subtle.importKey(
    'pkcs8',
    pemToArrayBuffer(account.private_key),
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  )

  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    key,
    new TextEncoder().encode(signingInput),
  )

  const assertion = `${signingInput}.${base64UrlEncode(new Uint8Array(signature))}`

  const response = await fetch(tokenUri, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion,
    }),
  })

  if (!response.ok) {
    const errText = await response.text()
    throw new Error(`Google token exchange failed: ${errText}`)
  }

  const data = await response.json()
  cachedToken = {
    token: data.access_token,
    expiresAt: now + (data.expires_in ?? 3600),
  }
  return cachedToken.token
}
