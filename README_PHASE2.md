# VeriScript Mobile — Codex Phase 2 Build Instructions

> **For Codex:** Read this entire file before writing a single line of code.
> Phase 1 must be fully merged and tagged `v0.1.0-phase1` before starting.
> Work through every section in order. One branch per feature. Commit after each task.
> Sections marked `🔑 DEVELOPER ACTION REQUIRED` need the human developer — leave a `// TODO: DEVELOPER ACTION` comment and continue.

---

## Table of Contents

1. [Phase 2 Scope](#1-phase-2-scope)
2. [Git Branching Rules](#2-git-branching-rules)
3. [Task 1 — Supabase Edge Functions (All 4 Live)](#3-task-1--supabase-edge-functions-all-4-live-branch-featureedge-functions)
4. [Task 2 — Plagiarism Scanner](#4-task-2--plagiarism-scanner-branch-featurescanner)
5. [Task 3 — Originality Report Screen](#5-task-3--originality-report-screen-branch-featurereport)
6. [Task 4 — OCR Scanner](#6-task-4--ocr-scanner-branch-featureocr)
7. [Task 5 — Neural Translator](#7-task-5--neural-translator-branch-featuretranslator)
8. [Task 6 — History Sync](#8-task-6--history-sync-branch-featurehistory-sync)
9. [Task 7 — Google Drive Integration](#9-task-7--google-drive-integration-branch-featurecloud-drive)
10. [Task 8 — Push Notifications](#10-task-8--push-notifications-branch-featurenotifications)
11. [Task 9 — Offline Sync Resolution](#11-task-9--offline-sync-resolution-branch-featureoffline-sync)
12. [Task 10 — Referral System](#12-task-10--referral-system-branch-featurereferral)
13. [Task 11 — Converter (Real CloudConvert)](#13-task-11--converter-real-cloudconvert-branch-featureconverter-live)
14. [Task 12 — ARB Updates (All New Strings)](#14-task-12--arb-updates-branch-featurei18n-p2)
15. [Task 13 — Tests](#15-task-13--tests-branch-featuretests)
16. [Task 14 — Performance Pass](#16-task-14--performance-pass-branch-featureperformance)
17. [Task 15 — Final Merge + Beta Tag](#17-task-15--final-merge--beta-tag)
18. [Gemini Android Studio Instructions](#18-gemini-android-studio-instructions)
19. [Developer Action Checklist](#19-developer-action-checklist)
20. [Phase 3 Preview](#20-phase-3-preview)

---

## 1. Phase 2 Scope

Phase 1 delivered a complete, polished UI shell with working auth, home dashboard, file converter (simulated), local DB, and bilingual support.

**Phase 2 makes everything real:**

| Feature | Phase 1 State | Phase 2 Target |
|---|---|---|
| Plagiarism Scanner | Stub screen | Full Copyleaks API flow + report screen |
| OCR Scanner | Stub screen | Live ML Kit camera + text output |
| Translator | Stub screen | Google Cloud Translate + cache |
| History | Drift-only, no sync | Full Supabase ↔ Drift two-way sync |
| File Converter | Simulated Edge Function | Real CloudConvert API |
| Edge Functions | 1 stub (`convert-file`) | 4 live functions deployed |
| Google Drive | Not started | OAuth + file browser + import/export |
| Push Notifications | Package installed | Wired to scan/conversion completion |
| Offline Sync | Read-only cache | Full reconciliation on reconnect |
| Referral System | Not started | Unique codes + WhatsApp share + bonus scans |

### New pubspec.yaml additions

Add these to `dependencies` in `pubspec.yaml` before starting any task:

```yaml
  # Phase 2 additions
  url_launcher: ^6.3.0          # open signed download URLs
  image_picker: ^1.1.0          # gallery import for OCR
  image_cropper: ^7.0.0         # crop before OCR
  flutter_markdown: ^0.7.3      # render report source details
  pdf: ^3.10.8                  # client-side PDF generation fallback
  printing: ^5.13.1             # print/share PDFs
  open_file: ^3.3.2             # open downloaded converted files
  workmanager: ^0.5.2           # background sync tasks
  crypto: ^3.0.3                # referral code generation
```

Run `flutter pub get` after adding.

---

## 2. Git Branching Rules

Same rules as Phase 1 — mandatory.

```
main        ← production only. Never commit directly.
develop     ← integration branch. All features merge here.
feature/xxx ← one branch per task, cut from develop.
```

```bash
# Before every task:
git checkout develop
git pull origin develop
git checkout -b feature/task-name

# After every task:
git checkout develop
git merge feature/task-name --no-ff
git push origin develop
```

### Phase 2 branch map

| Branch | Purpose |
|---|---|
| `feature/edge-functions` | All 4 Edge Functions deployed live |
| `feature/scanner` | Plagiarism scanner full implementation |
| `feature/report` | Originality report screen + PDF export |
| `feature/ocr` | OCR camera + gallery + text output |
| `feature/translator` | Neural translator full implementation |
| `feature/history-sync` | History two-way Supabase ↔ Drift sync |
| `feature/cloud-drive` | Google Drive OAuth + file browser |
| `feature/notifications` | Push notifications for scan/convert complete |
| `feature/offline-sync` | Offline queue + reconnect reconciliation |
| `feature/referral` | Referral codes + WhatsApp share + bonus scans |
| `feature/converter-live` | Replace simulated converter with real CloudConvert |
| `feature/i18n-p2` | All new ARB strings for Phase 2 features |
| `feature/tests` | Unit + widget + integration tests |
| `feature/performance` | DevTools profiling fixes |

---

## 3. Task 1 — Supabase Edge Functions (All 4 Live) (branch: `feature/edge-functions`)

```bash
git checkout develop && git checkout -b feature/edge-functions
```

> 🔑 **DEVELOPER ACTION REQUIRED — Before Codex starts this task:**
> 1. Go to Supabase Dashboard → Settings → API → copy your **Service Role Key**
> 2. In terminal: `supabase secrets set COPYLEAKS_KEY=your_key`
> 3. In terminal: `supabase secrets set CLOUDCONVERT_KEY=your_key`
> 4. In terminal: `supabase secrets set GOOGLE_TRANSLATE_KEY=your_key`
> 5. In terminal: `supabase secrets set SUPABASE_SERVICE_ROLE_KEY=your_service_role_key`
> 6. Verify: `supabase secrets list` — all 4 keys must appear
> Codex writes all function code. You deploy them.

### Shared Edge Function utilities

Create `supabase/functions/_shared/cors.ts`:

```typescript
export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}
```

Create `supabase/functions/_shared/supabase_admin.ts`:

```typescript
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

export const supabaseAdmin = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  { auth: { autoRefreshToken: false, persistSession: false } }
)
```

### Edge Function 1 — `/scan-document`

**File:** `supabase/functions/scan-document/index.ts`

Flow:
1. Receive `{ jobId, storagePath, documentId, userId }` from Flutter
2. Update `scan_reports` row status to `'processing'`
3. Get signed URL for the file from Supabase Storage `documents` bucket
4. Submit to Copyleaks API:
   - `POST https://api.copyleaks.com/v3/education/submit/url/{scanId}`
   - Auth: `Bearer` token from `POST https://id.copyleaks.com/v3/account/login/api`
   - Body: `{ url: signedUrl, properties: { webhooks: { status: "{YOUR_SUPABASE_EDGE_FUNCTION_URL}/copyleaks-webhook" } } }`
5. Save Copyleaks `scanId` to `scan_reports` row as `external_scan_id`
6. Return `{ success: true, scanId }`

> 🔑 **DEVELOPER ACTION REQUIRED:**
> After deploying this function, go to Copyleaks Dashboard → Settings → Webhooks.
> Set the webhook URL to: `https://YOUR_PROJECT_REF.supabase.co/functions/v1/copyleaks-webhook`
> Leave a `// TODO: DEVELOPER ACTION — set Copyleaks webhook URL` comment in the code.

### Edge Function 2 — `/copyleaks-webhook`

**File:** `supabase/functions/copyleaks-webhook/index.ts`

This receives callbacks FROM Copyleaks when a scan completes:

```typescript
// Copyleaks sends POST with scan results
// Body shape: { scanId, status, results: { score: { aggregatedScore }, comparison: [...sources] } }

// On receive:
// 1. Find scan_reports row where external_scan_id = scanId
// 2. Map aggregatedScore (0-100) to similarity_pct
// 3. Map comparison array to sources JSON:
//    each source: { url, title, matchedPercent, matchedWords }
// 4. Update scan_reports: status='done', similarity_pct, sources (JSONB)
// 5. Supabase Realtime will automatically notify the Flutter app via the existing subscription
```

### Edge Function 3 — `/translate-text`

**File:** `supabase/functions/translate-text/index.ts`

```typescript
// Receive: { text, sourceLang, targetLang, userId, documentId? }
// 
// 1. Check translations table for cached result:
//    SELECT * FROM translations WHERE user_id=userId AND input_text=text 
//    AND source_lang=sourceLang AND target_lang=targetLang
//    If found: return cached result immediately
//
// 2. Call Google Cloud Translate v3:
//    POST https://translation.googleapis.com/language/translate/v2
//    Headers: { 'X-goog-api-key': GOOGLE_TRANSLATE_KEY }
//    Body: { q: text, source: sourceLang, target: targetLang, format: 'text' }
//
// 3. Insert result to translations table
//
// 4. Update usage_quotas: chars_translated += text.length
//
// 5. Return { translatedText, detectedSourceLang, charCount }
```

### Edge Function 4 — `/export-report-pdf`

**File:** `supabase/functions/export-report-pdf/index.ts`

```typescript
// Receive: { reportId, userId }
//
// 1. Fetch scan_reports row (verify user_id matches userId — RLS enforcement)
// 2. Fetch document name from documents table
// 3. Build HTML report template string:
//    - VeriScript header with logo text
//    - Document name, scan date
//    - Large similarity percentage (color coded: green/orange/red)
//    - Source list: each source with URL, matched %, excerpt
//    - Footer: "Generated by VeriScript"
//
// 4. Use a Deno HTML-to-PDF library OR return the HTML directly
//    Recommended: return HTML with Content-Type text/html
//    Flutter will render it with url_launcher or printing package
//    
//    If using a PDF library (e.g. pdfmake via CDN import):
//    Generate PDF buffer → upload to Supabase Storage 'reports' bucket
//    at path: userId/reportId.pdf
//    Update scan_reports.report_pdf_url with signed URL
//    Return { pdfUrl }
//
// 5. If PDF generation fails: return { htmlContent } as fallback
//    Flutter shows a WebView with the HTML
```

### Deploy instruction (Codex writes this, developer runs it)

Create `supabase/functions/DEPLOY.md`:

```markdown
# Deploy Edge Functions

Run these commands from the project root after adding your API keys to Supabase secrets:

supabase functions deploy scan-document
supabase functions deploy copyleaks-webhook  
supabase functions deploy translate-text
supabase functions deploy export-report-pdf
supabase functions deploy convert-file

Verify deployment:
supabase functions list

Test scan-document locally first:
supabase functions serve scan-document --env-file .env.local
```

### Add `external_scan_id` column to scan_reports

Create `supabase/migrations/20240001_add_external_scan_id.sql`:

```sql
ALTER TABLE public.scan_reports 
ADD COLUMN IF NOT EXISTS external_scan_id TEXT;

CREATE INDEX IF NOT EXISTS idx_scan_reports_external_id 
ON public.scan_reports(external_scan_id);
```

> 🔑 **DEVELOPER ACTION REQUIRED:**
> Run this migration in Supabase SQL Editor before deploying the scanner Edge Function.

Commit: `feat: all 4 Edge Functions — scan, copyleaks-webhook, translate, export-pdf`

Merge: `git checkout develop && git merge feature/edge-functions --no-ff`

---

## 4. Task 2 — Plagiarism Scanner (branch: `feature/scanner`)

```bash
git checkout develop && git checkout -b feature/scanner
```

### Domain models

**`lib/features/scanner/domain/scan_job.dart`** (Freezed):

```dart
@freezed
class ScanJob with _$ScanJob {
  const factory ScanJob({
    required String id,
    required String documentId,
    required String userId,
    required String status,        // pending|processing|done|failed
    double? similarityPct,
    List<ScanSource>? sources,
    String? reportPdfUrl,
    String? externalScanId,
    required DateTime createdAt,
  }) = _ScanJob;
}

@freezed
class ScanSource with _$ScanSource {
  const factory ScanSource({
    required String url,
    required String title,
    required double matchedPercent,
    int? matchedWords,
  }) = _ScanSource;

  factory ScanSource.fromJson(Map<String, dynamic> json) => _$ScanSourceFromJson(json);
}
```

### `lib/features/scanner/data/scan_repository.dart`

Methods:

```dart
// Upload document to Supabase Storage 'documents' bucket
// Returns storage path: 'userId/uuid_filename.ext'
Future<String> uploadDocument(File file, String userId)

// Insert to documents table + insert to scan_reports with status 'pending'
// Returns { documentId, reportId }
Future<({String documentId, String reportId})> createScanJob(
  String storagePath, String fileName, String fileType, String userId
)

// Call /scan-document Edge Function
// Returns Copyleaks scanId
Future<void> startScan(String reportId, String storagePath, String documentId, String userId)

// Supabase Realtime stream on scan_reports row
// Emits ScanJob every time status/similarity_pct changes
Stream<ScanJob> watchScanJob(String reportId)

// Fetch completed scan report
Future<ScanJob> getScanReport(String reportId)

// Increment usage_quotas.scans_used for user
Future<void> incrementScanCount(String userId)

// Check if user has scans remaining (free: 3/month, plus: unlimited)
Future<bool> canScan(String userId)
```

### `lib/features/scanner/presentation/scanner_notifier.dart`

`AsyncNotifier` managing `ScannerState`:

```dart
class ScannerState {
  final File? selectedFile;
  final String? fileName;
  final int? fileSizeBytes;
  final String scanStatus;  // idle|uploading|scanning|done|failed|quota_exceeded
  final String? currentReportId;
  final double? progressEstimate;  // 0.0-1.0 simulated progress during scan
  final String? errorMessage;
}
```

Methods:
- `pickDocument()` — file_picker, allow PDF/DOCX/TXT only, max 10MB
- `startScan()` — orchestrates upload → createScanJob → startScan → subscribe to Realtime
- `reset()` — clears state
- On `quota_exceeded`: set state to reflect this, do not call API

### `lib/features/scanner/presentation/scanner_screen.dart`

**3 states:**

**State 1 — Upload (scanStatus == 'idle'):**

- `VsAppBar` title: `'Plagiarism Check'` / `'Vérification de plagiat'`
- Quota indicator at top: `'2 of 3 free scans used this month'` / `'2 sur 3 analyses gratuites utilisées ce mois'`
  - `LinearPercentIndicator`, color logic same as home quota bar
  - If 0 remaining: full-width warning card with `'Scan limit reached for this month'` / `'Limite d\'analyses atteinte pour ce mois'`
- Large upload area (same dashed style as converter):
  - `Icon(Icons.document_scanner_rounded, size: 72, color: vsAccent)`
  - `'Tap to upload a document'` / `'Appuyez pour importer un document'`
  - `'PDF, DOCX or TXT · Max 10MB'`
  - `'Your document is scanned against billions of sources'` / `'Votre document est analysé contre des milliards de sources'` in `bodySmall vsGray`
- After file picked — file info card:
  - File icon, name, size
  - Data usage warning if > 3MB: `'This may use significant mobile data'` / `'Cela peut consommer des données mobiles importantes'`
  - `VsButton.primary('Scan for Plagiarism')` / `'Analyser le plagiat'`
  - `VsButton.text('Choose different file')` / `'Choisir un autre fichier'`

**State 2 — Scanning (uploading | scanning):**

- `VsAppBar` with no back button during scan (disable pop)
- Large animated progress area:
  - Circular progress indicator (vsAccent, strokeWidth: 6, size: 120)
  - Percentage text in center if progress estimate available
  - Status text below (animated, cycling every 4 seconds):
    - Cycle 1: `'Uploading document...'` / `'Téléchargement du document...'`
    - Cycle 2: `'Scanning against web sources...'` / `'Analyse contre les sources web...'`
    - Cycle 3: `'Checking academic databases...'` / `'Vérification des bases de données académiques...'`
    - Cycle 4: `'Generating your report...'` / `'Génération de votre rapport...'`
  - Small note: `'This usually takes 30–120 seconds'` / `'Cela prend généralement 30 à 120 secondes'`
  - `TextButton('Cancel')` / `'Annuler'` → cancels Realtime subscription, resets state

**State 3 — Error / quota exceeded:**
- `VsErrorView` for general errors
- Special quota card for quota_exceeded (see design above)

> Note: The result (State 3 — done) is its own screen. On `scanStatus == 'done'`, navigate to `/scanner/result/:reportId`.

Commit: `feat: plagiarism scanner — file upload, Copyleaks integration, Realtime progress`

Merge: `git checkout develop && git merge feature/scanner --no-ff`

---

## 5. Task 3 — Originality Report Screen (branch: `feature/report`)

```bash
git checkout develop && git checkout -b feature/report
```

Add route to `app_routes.dart`:
```dart
static const String scanResult = '/scanner/result/:reportId';
```

Add to router in `app_router.dart`:
```dart
GoRoute(
  path: '/scanner/result/:reportId',
  builder: (context, state) => ScanResultScreen(
    reportId: state.pathParameters['reportId']!,
  ),
),
```

### `lib/features/scanner/presentation/scan_result_screen.dart`

Receives `reportId`. On init, fetches the full `ScanJob` from Supabase.

**Layout — `CustomScrollView`:**

**Section 1 — Similarity Ring:**

White `VsCard`, padding 24, centered:
- `fl_chart` `PieChart` (or `RadialBarChart`) — donut chart:
  - Outer ring represents similarity percentage
  - Inner ring represents original percentage
  - Colours:
    - similarity < 30% → `vsLowSimilarity` (green)
    - 30–70% → `vsMedSimilarity` (orange)
    - > 70% → `vsHighSimilarity` (red)
  - Center text: `'72%'` in `displayLarge` with same colour
  - Below: `'Similarity Score'` / `'Score de similarité'` in `bodySmall vsGray`
- Below chart:
  - `Text(documentName)` in `titleLarge`
  - `Text(formattedDate)` in `bodySmall vsGray`
  - Severity label row:
    - < 30%: green chip `'Low Risk — Likely Original'` / `'Risque faible — Probablement original'`
    - 30–70%: orange chip `'Medium Risk — Review Required'` / `'Risque moyen — Révision requise'`
    - > 70%: red chip `'High Risk — Significant Matches Found'` / `'Risque élevé — Correspondances significatives'`

**Section 2 — Action buttons:**

Horizontal row:
- `ElevatedButton.icon(Icons.picture_as_pdf, 'Export PDF')` / `'Exporter PDF'` → calls `/export-report-pdf` Edge Function → opens with `printing` package
- `OutlinedButton.icon(Icons.share, 'Share')` / `'Partager'` → `share_plus` with report summary text
- `OutlinedButton.icon(Icons.refresh, 'Rescan')` / `'Analyser à nouveau'` → only if status is failed

**Section 3 — Sources breakdown:**

Header: `'Matched Sources'` / `'Sources correspondantes'` — `titleLarge` + source count badge

`ListView.builder` (non-scrolling inside `CustomScrollView` — use `shrinkWrap: true, physics: NeverScrollableScrollPhysics()`):

Each source card — `VsCard` with `InkWell`:
- Left: percentage badge — coloured circle with `'42%'` in bold white
- Middle: source title (1 line, ellipsis), URL (1 line, `vsGray`, `bodySmall`)
- Right: `Icons.open_in_new` → `url_launcher` opens the URL
- Bottom (expandable `ExpansionTile`): matched word count, excerpt if available

If `sources` is empty or null:
- `VsEmptyState` with text `'No specific sources identified'` / `'Aucune source spécifique identifiée'`

**Export PDF flow:**

On `'Export PDF'` button tap:
1. Show `VsLoadingOverlay`
2. Call `/export-report-pdf` Edge Function with `reportId`
3. On success with `pdfUrl`: open with `printing.Printing.sharePdf()` — shows system share sheet
4. On success with `htmlContent`: use `printing` package to convert HTML to PDF in-app
5. On failure: show `SnackBar` with error + `'Try again'`

Commit: `feat: originality report screen — similarity ring, source list, PDF export`

Merge: `git checkout develop && git merge feature/report --no-ff`

---

## 6. Task 4 — OCR Scanner (branch: `feature/ocr`)

```bash
git checkout develop && git checkout -b feature/ocr
```

### `lib/features/ocr/data/ocr_service.dart`

```dart
class OcrService {
  // Uses google_mlkit_text_recognition
  // TextRecognizer instance — initialise once, close on dispose
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  // Process an image file → returns recognised text string
  Future<String> recogniseText(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final recognised = await _textRecognizer.processImage(inputImage);
    return recognised.text;
  }

  // Process a camera image → returns recognised text
  Future<String> recogniseFromCameraImage(XFile xFile) async {
    final inputImage = InputImage.fromFilePath(xFile.path);
    final recognised = await _textRecognizer.processImage(inputImage);
    return recognised.text;
  }

  void dispose() => _textRecognizer.close();
}

// Riverpod provider
final ocrServiceProvider = Provider((ref) {
  final service = OcrService();
  ref.onDispose(service.dispose);
  return service;
});
```

### `lib/features/ocr/presentation/ocr_notifier.dart`

`AsyncNotifier` managing `OcrState`:

```dart
class OcrState {
  final OcrSource source;      // none | camera | gallery
  final File? imageFile;
  final String ocrStatus;      // idle | processing | done | failed
  final String recognisedText;
  final String? errorMessage;
}
```

Methods:
- `captureFromCamera()` — launches camera, gets `XFile`, calls `ocrService.recogniseFromCameraImage`
- `pickFromGallery()` — `image_picker` gallery, then `image_cropper` for crop, then recognise
- `copyText()` — copies `recognisedText` to clipboard
- `sendToTranslator()` — navigates to `/translator` with `recognisedText` pre-filled
- `sendToConverter()` — saves text as `.txt` to temp directory, navigates to `/converter` with file pre-selected
- `reset()`

### `lib/features/ocr/presentation/ocr_screen.dart`

**State 1 — Source selection (ocrStatus == 'idle' && imageFile == null):**

- `VsAppBar` title: `'OCR Scanner'` / `'Numériseur OCR'`
- Info card (vsAccent left border):
  - `'Scan any physical document with your camera'` / `'Numérisez tout document physique avec votre caméra'`
  - `'Works best with: printed text, lecture notes, books, handouts'` / `'Fonctionne mieux avec: texte imprimé, notes de cours, livres, polycopiés'`
  - `'On-device processing — nothing leaves your phone'` / `'Traitement sur l\'appareil — rien ne quitte votre téléphone'` — `Icons.lock` icon in vsSuccess
- Two large option buttons:
  - `VsButton.primary(icon: Icons.camera_alt_rounded, 'Take Photo')` / `'Prendre une photo'` → `captureFromCamera()`
  - `VsButton.secondary(icon: Icons.photo_library_rounded, 'Choose from Gallery')` / `'Choisir dans la galerie'` → `pickFromGallery()`
- Small note: `'Supported: Latin scripts, printed text in 50+ languages'` / `'Supporté: scripts latins, texte imprimé en 50+ langues'`

**State 2 — Processing (ocrStatus == 'processing'):**

- `VsLoadingOverlay` with text `'Reading your document...'` / `'Lecture de votre document...'`
- Show the selected image as background (blurred, 0.3 opacity) so user can see what's being processed

**State 3 — Result (ocrStatus == 'done'):**

Split view:
- Top half: the captured image in a `ClipRRect` (radius 12), max height 200
- Bottom half: white card with:
  - `Text('Recognised Text')` / `'Texte reconnu'` — `titleLarge` + character count badge
  - `TextField` (multi-line, read-only initially) showing `recognisedText`
  - Edit toggle: `IconButton(Icons.edit)` to make the TextField editable
  - Action row (horizontal scroll):
    - `OutlinedButton.icon(Icons.copy, 'Copy')` / `'Copier'`
    - `OutlinedButton.icon(Icons.translate, 'Translate')` / `'Traduire'` → `sendToTranslator()`
    - `OutlinedButton.icon(Icons.swap_horiz, 'Convert')` / `'Convertir'` → `sendToConverter()`
    - `OutlinedButton.icon(Icons.camera_alt, 'Scan Again')` / `'Numériser à nouveau'` → `reset()`
- If `recognisedText` is empty: `VsErrorView` with `'No text detected. Try better lighting or a clearer image.'` / `'Aucun texte détecté. Essayez un meilleur éclairage ou une image plus nette.'`

**State 4 — Failed:**
- `VsErrorView(message: errorMessage, onRetry: reset)`

### Android permissions

Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera" android:required="false"/>
```

Add camera permission request using `permission_handler` package:

```yaml
# Add to pubspec.yaml:
permission_handler: ^11.3.0
```

In `OcrNotifier.captureFromCamera()`:
```dart
final status = await Permission.camera.request();
if (!status.isGranted) {
  // Show snackbar: 'Camera permission required'
  return;
}
```

Commit: `feat: OCR scanner — camera capture, gallery import, ML Kit on-device recognition, result actions`

Merge: `git checkout develop && git merge feature/ocr --no-ff`

---

## 7. Task 5 — Neural Translator (branch: `feature/translator`)

```bash
git checkout develop && git checkout -b feature/translator
```

### Language model

**`lib/features/translator/domain/language.dart`**:

```dart
class Language {
  final String code;   // e.g. 'fr', 'en', 'de'
  final String nameEn; // English name
  final String nameFr; // French name
  const Language({required this.code, required this.nameEn, required this.nameFr});
}

// Top languages for Cameroon context — prioritise these in the picker:
const kPriorityLanguages = [
  Language(code: 'fr', nameEn: 'French', nameFr: 'Français'),
  Language(code: 'en', nameEn: 'English', nameFr: 'Anglais'),
  Language(code: 'de', nameEn: 'German', nameFr: 'Allemand'),
  Language(code: 'es', nameEn: 'Spanish', nameFr: 'Espagnol'),
  Language(code: 'zh', nameEn: 'Chinese', nameFr: 'Chinois'),
  Language(code: 'ar', nameEn: 'Arabic', nameFr: 'Arabe'),
  Language(code: 'pt', nameEn: 'Portuguese', nameFr: 'Portugais'),
];
// Then all other ISO 639-1 languages alphabetically
```

### `lib/features/translator/data/translation_repository.dart`

```dart
// Call /translate-text Edge Function
Future<TranslationResult> translateText({
  required String text,
  required String sourceLang,  // 'auto' for auto-detect
  required String targetLang,
  required String userId,
  String? documentId,
})

// Check Drift cache first before calling API
Future<TranslationResult?> getCachedTranslation(
  String userId, String text, String source, String target
)

// Increment usage_quotas.chars_translated
Future<void> updateCharCount(String userId, int charCount)

// Check if user has chars remaining
Future<bool> canTranslate(String userId, int textLength)
```

### `lib/features/translator/presentation/translator_notifier.dart`

`AsyncNotifier` managing `TranslatorState`:

```dart
class TranslatorState {
  final String inputText;
  final String sourceLang;      // default: 'auto'
  final String targetLang;      // default: 'fr' if device is EN, 'en' if device is FR
  final String translatorStatus; // idle|translating|done|failed|quota_exceeded
  final String? translatedText;
  final String? detectedSourceLang;
  final int charsUsedThisMonth;
  final int charsLimit;          // 5000 free, 500000 plus
  final String? errorMessage;
  final bool fromOcr;            // true if text came from OCR screen
}
```

Methods:
- `setInputText(String text)` — debounced, triggers translation after 800ms pause
- `setSourceLang(String lang)`
- `setTargetLang(String lang)`
- `swapLanguages()` — swap source ↔ target, move translated text to input
- `translate()` — calls repository, checks cache first
- `copyTranslation()` — clipboard
- `clearInput()`
- `initWithText(String text)` — used when arriving from OCR screen

### `lib/features/translator/presentation/translator_screen.dart`

Accept optional `initialText` parameter (for OCR → Translator flow).

**Layout:**

- `VsAppBar` title: `'Translator'` / `'Traducteur'`
- **Language selector bar** (full width, `vsPrimary` background):
  - `[Source language dropdown] [swap icon button] [Target language dropdown]`
  - Source includes `'Auto-detect'` / `'Détection auto'` as first option
  - Dropdowns use a custom bottom sheet language picker (not the default dropdown)
- **Input area** (white card):
  - `TextField` — multiline, max 5000 chars, `'Enter text to translate...'` / `'Entrez le texte à traduire...'`
  - Character counter: `'342 / 5000'` — turns orange at 4000, red at 5000
  - If `fromOcr`: pre-fill with OCR text and show chip `'From OCR Scanner'` / `'Depuis le numériseur OCR'`
  - Action row: `IconButton(Icons.clear)` to clear, `VsButton.primary('Translate')` / `'Traduire'`
  - Auto-translate: call `translate()` on 800ms debounce after text changes
- **Quota bar** (small, between input and output):
  - `'2,450 / 5,000 chars used this month'` / `'2 450 / 5 000 caractères utilisés ce mois'`
  - `LinearPercentIndicator` — same colour logic as home quota bars
- **Output area** (vsBackground card):
  - If `translatorStatus == 'idle'`: placeholder text in `vsGray` italic: `'Translation will appear here'` / `'La traduction apparaîtra ici'`
  - If `translatorStatus == 'translating'`: `Shimmer` effect on 3 placeholder lines
  - If `translatorStatus == 'done'`:
    - Translated text in `bodyLarge`
    - If `detectedSourceLang != sourceLang`: small chip `'Detected: French'` / `'Détecté: Français'`
    - Action row: `IconButton(Icons.copy, 'Copy')`, `IconButton(Icons.volume_up, 'Listen')` (placeholder — Phase 3), `IconButton(Icons.swap_horiz, 'Use as input')` (swapLanguages)
  - If `translatorStatus == 'failed'`: `VsErrorView`
  - If `translatorStatus == 'quota_exceeded'`: quota exceeded card with upgrade nudge
- **Cache badge**: if result came from cache, show small `'⚡ Instant — from cache'` / `'⚡ Instantané — depuis le cache'` badge in `vsSuccess`

### Language picker bottom sheet

Triggered by tapping either language dropdown button:

- `DraggableScrollableSheet` (initial: 0.6, max: 0.9)
- `TextField` search bar at top — filters language list
- Priority languages section first (with `'Recommended'` / `'Recommandé'` header)
- All other languages alphabetically
- Selected language gets `vsAccent` background
- On tap: close sheet, update notifier

Commit: `feat: neural translator — language picker, auto-translate, cache, OCR integration`

Merge: `git checkout develop && git merge feature/translator --no-ff`

---

## 8. Task 6 — History Sync (branch: `feature/history-sync`)

```bash
git checkout develop && git checkout -b feature/history-sync
```

### `lib/features/history/data/history_repository.dart`

```dart
// Fetch paginated history from Supabase (documents + related scan_reports/conversion_jobs)
Future<List<HistoryItem>> fetchRemoteHistory(String userId, {int page = 0, int pageSize = 20})

// Sync remote items to Drift local DB
Future<void> syncToLocal(List<HistoryItem> items)

// Watch local history (Drift stream — always available, even offline)
Stream<List<HistoryItem>> watchLocalHistory(String userId)

// Delete document — from Supabase Storage, documents table, and Drift
Future<void> deleteDocument(String documentId, String storagePath, String userId)

// Search local documents by name
Stream<List<HistoryItem>> searchLocalHistory(String userId, String query)
```

### `lib/features/history/domain/history_item.dart`

```dart
@freezed
class HistoryItem with _$HistoryItem {
  const factory HistoryItem({
    required String id,
    required String documentId,
    required String name,
    required String type,          // pdf|docx|txt
    required String action,        // scan|convert|translate|ocr
    required String status,        // done|failed|processing
    required DateTime createdAt,
    double? similarityPct,         // for scans
    String? fromFormat,            // for conversions
    String? toFormat,              // for conversions
    String? sourceLang,            // for translations
    String? targetLang,            // for translations
  }) = _HistoryItem;
}
```

### `lib/features/history/presentation/history_screen.dart`

Full implementation replacing the Phase 1 Drift-only stub:

**App bar:**
- `VsAppBar` title: `'History'` / `'Historique'`
- Trailing `IconButton(Icons.search)` → toggles search bar
- Trailing `IconButton(Icons.filter_list)` → opens filter bottom sheet

**Filter bottom sheet:**
- Filter by action type: `All` / `Scans` / `Conversions` / `Translations` / `OCR`
- Sort by: `Newest first` / `Oldest first`
- Filter by status: `All` / `Completed` / `Failed`

**Search bar** (slide down when search icon tapped):
- `TextField` with `vsAccent` focus border
- Real-time filter on `history_repository.searchLocalHistory`

**List — `ListView.builder` with `RefreshIndicator`:**

Each `HistoryItem` card — `Dismissible` (swipe left to delete):

- Left section: action icon in coloured circle:
  - scan → `Icons.document_scanner_rounded` in `vsPrimary` circle
  - convert → `Icons.swap_horiz_rounded` in `vsAccent` circle
  - translate → `Icons.translate_rounded` in `vsCta` circle
  - ocr → `Icons.camera_alt_rounded` in `vsWarning` circle
- Middle: document name (1 line), subtitle (action description), date
  - scan subtitle: `'Similarity: 45%'` / `'Similarité: 45%'` with colour badge
  - convert subtitle: `'PDF → DOCX'`
  - translate subtitle: `'EN → FR'`
- Right: status chip + `IconButton(Icons.more_vert)` → options menu (Delete, Re-run, Share)

**Swipe-to-delete confirmation:**
- Red background with `Icons.delete_forever` icon
- On confirm: `history_repository.deleteDocument` — removes from Supabase Storage + DB + Drift
- Show `SnackBar` with `Undo` action (5 second window)

**Pull-to-refresh:**
- `RefreshIndicator` → `history_repository.fetchRemoteHistory` + `syncToLocal`
- Shimmer loading cards while fetching

**Pagination:**
- Load more on scroll (last item triggers `page + 1` fetch)
- Loading spinner at bottom while fetching more

**Empty state:**
- `VsEmptyState(lottie: 'empty.json', title: 'No history yet', subtitle: 'Your processed documents will appear here')`

Commit: `feat: history — full Supabase sync, search, filter, pagination, swipe-to-delete`

Merge: `git checkout develop && git merge feature/history-sync --no-ff`

---

## 9. Task 7 — Google Drive Integration (branch: `feature/cloud-drive`)

```bash
git checkout develop && git checkout -b feature/cloud-drive
```

> 🔑 **DEVELOPER ACTION REQUIRED — Before Codex starts:**
> 1. Go to console.cloud.google.com
> 2. Select your existing project (same one used for Translate API)
> 3. Enable: Google Drive API
> 4. Create OAuth 2.0 credentials → Android → enter package name `com.veriscipt.mobile`
> 5. Get your SHA-1 fingerprint: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`
> 6. Add SHA-1 to the OAuth credential
> 7. Download `google-services.json` and place in `android/app/`
> Leave a `// TODO: DEVELOPER ACTION — add google-services.json` comment.

### New route

Add to `app_routes.dart`:
```dart
static const String cloudDrive = '/cloud/drive';
```

Add to bottom navigation as a conditional tab OR as a button in the Home dashboard and Settings screen (do not add a 6th bottom nav item — keep 5 tabs).

Add `'Cloud Drive'` / `'Google Drive'` as a `ListTile` in Settings screen.

### `lib/features/cloud/data/drive_repository.dart`

```dart
// Sign in with Google (Drive scope)
Future<GoogleSignInAccount?> signIn()

// Sign out
Future<void> signOut()

// Check if signed in
bool get isSignedIn

// List files in Drive root (or folder)
// Filter: only PDF, DOCX, TXT
Future<List<DriveFile>> listFiles({String? folderId, String? pageToken})

// Download a Drive file to local temp directory
// Returns the local File
Future<File> downloadFile(DriveFile driveFile)

// Upload a local file to Drive
Future<String> uploadFile(File localFile, String fileName, String mimeType)
```

### `lib/features/cloud/domain/drive_file.dart`

```dart
@freezed
class DriveFile with _$DriveFile {
  const factory DriveFile({
    required String id,
    required String name,
    required String mimeType,
    int? sizeBytes,
    required DateTime modifiedTime,
    String? webViewLink,
  }) = _DriveFile;
}
```

### `lib/features/cloud/presentation/drive_notifier.dart`

`AsyncNotifier` managing `DriveState`:
```dart
class DriveState {
  final bool isSignedIn;
  final String? userEmail;
  final List<DriveFile> files;
  final bool isLoading;
  final String? nextPageToken;
  final String? errorMessage;
}
```

Methods:
- `signIn()`, `signOut()`
- `loadFiles({String? folderId})`
- `loadMore()` — pagination using `nextPageToken`
- `importFile(DriveFile file)` → downloads to local temp → navigates to appropriate feature screen (converter/scanner) with file pre-selected
- `exportFile(File localFile, String name)` → uploads to Drive

### `lib/features/cloud/presentation/drive_screen.dart`

**Not signed in state:**
- Centred `VsEmptyState` with `Icons.cloud_off` (no Lottie here — keep it clean)
- `'Connect Google Drive'` / `'Connecter Google Drive'`
- `'Import and export documents directly from your Drive'` / `'Importez et exportez des documents directement depuis votre Drive'`
- `VsButton.primary('Connect with Google')` / `'Connecter avec Google'` → `driveNotifier.signIn()`

**Signed in state:**
- `VsAppBar` title: `'Google Drive'` + user email as subtitle
- Trailing `IconButton(Icons.logout)` → `driveNotifier.signOut()`
- `RefreshIndicator` + `ListView.builder` of `DriveFile` items:
  - File icon (by MIME type), name, size, modified date
  - Trailing `IconButton(Icons.file_download)` → `driveNotifier.importFile(file)`
- Shimmer loading while fetching
- Pagination: load more on scroll
- Empty state: `'No supported files found in Drive'` / `'Aucun fichier supporté trouvé dans Drive'`

**Export from Converter screen:**
- After a successful conversion, add an `OutlinedButton.icon(Icons.upload, 'Save to Drive')` / `'Enregistrer dans Drive'` below the `'Download File'` button
- On tap: call `driveNotifier.exportFile(outputFile, outputFileName)`

Commit: `feat: Google Drive — OAuth, file browser, import to app, export from converter`

Merge: `git checkout develop && git merge feature/cloud-drive --no-ff`

---

## 10. Task 8 — Push Notifications (branch: `feature/notifications`)

```bash
git checkout develop && git checkout -b feature/notifications
```

> Note: Using `flutter_local_notifications` (already installed) for in-app/local notifications. FCM (Firebase Cloud Messaging) is Phase 3. For now, notifications are triggered locally when the app is in foreground or background (using `workmanager` for background).

### `lib/core/notifications/notification_service.dart`

```dart
class NotificationService {
  static const _channelId = 'veriscipt_main';
  static const _channelName = 'VeriScript';
  static const _channelDesc = 'Document processing notifications';

  Future<void> initialize() async {
    // Initialize flutter_local_notifications
    // Android: create notification channel
    // Request permission (Android 13+)
  }

  Future<void> showScanComplete({
    required String documentName,
    required double similarityPct,
    required String reportId,
  }) async {
    // Title: 'Scan Complete'
    // Body: '"documentName" — Similarity: 45%'
    // Payload: '/scanner/result/reportId' (for navigation on tap)
  }

  Future<void> showConversionComplete({
    required String documentName,
    required String toFormat,
    required String jobId,
  }) async {
    // Title: 'Conversion Complete'
    // Body: '"documentName" converted to FORMAT successfully'
  }

  Future<void> showTranslationComplete({
    required String sourceLang,
    required String targetLang,
  }) async {
    // Title: 'Translation Complete'
    // Body: 'sourceLang → targetLang translation ready'
  }

  // Handle notification tap → navigate to relevant screen
  // Use go_router to navigate based on payload
}

final notificationServiceProvider = Provider((ref) => NotificationService());
```

### Wire notifications into notifiers

**In `ScannerNotifier`:**
- When `watchScanJob` stream emits `status == 'done'`:
  - Call `notificationService.showScanComplete()`
  - Only if app is not in foreground (check `WidgetsBindingObserver`)

**In `ConverterNotifier`:**
- When job status stream emits `'done'`:
  - Call `notificationService.showConversionComplete()`

**In `TranslatorNotifier`:**
- After `translate()` completes (translation takes > 2 seconds):
  - Call `notificationService.showTranslationComplete()`

### Notification tap navigation

In `main.dart`, after Supabase init:

```dart
// Handle notification tap when app is launched from notification
final notificationAppLaunchDetails = await flutterLocalNotificationsPlugin
    .getNotificationAppLaunchDetails();
if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
  final payload = notificationAppLaunchDetails!.notificationResponse?.payload;
  if (payload != null) {
    // Store payload, navigate after router is ready
    initialDeepLink = payload;
  }
}
```

Commit: `feat: local push notifications for scan, conversion, and translation completion`

Merge: `git checkout develop && git merge feature/notifications --no-ff`

---

## 11. Task 9 — Offline Sync Resolution (branch: `feature/offline-sync`)

```bash
git checkout develop && git checkout -b feature/offline-sync
```

### Offline queue — `lib/core/local_db/tables/sync_queue_table.dart`

Add a new Drift table:

```dart
class SyncQueueTable extends Table {
  TextColumn get id => text()();          // uuid
  TextColumn get action => text()();      // 'upload_document'|'delete_document'|'update_scan'
  TextColumn get payload => text()();     // JSON string with all necessary data
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending|failed
}
```

Add `SyncQueueTable` to `AppDatabase` tables list. Run build_runner after.

### `lib/core/sync/sync_service.dart`

```dart
class SyncService {
  // Called by connectivityProvider listener when going online
  Future<void> processQueue() async {
    // 1. Read all pending items from sync_queue_table (ordered by createdAt)
    // 2. For each item, run the appropriate action:
    //    'upload_document' → upload to Supabase Storage, insert to documents table
    //    'delete_document' → delete from Supabase Storage + documents table
    //    'update_quota'    → sync local quota counts to Supabase usage_quotas
    // 3. On success: delete item from sync_queue_table
    // 4. On failure: increment retry_count; if retry_count >= 3, mark as 'failed'
    // 5. Show notification: 'Synced X documents from offline session' if > 0 items processed
  }

  // Queue an action for later sync
  Future<void> enqueue(String action, Map<String, dynamic> payload) async {
    // Insert to sync_queue_table
  }
}

final syncServiceProvider = Provider((ref) => SyncService(ref));
```

### Wire sync into connectivity provider

In `lib/core/providers/connectivity_provider.dart`, update to:

```dart
final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  final stream = Connectivity().onConnectivityChanged;
  
  // Side effect: when going from offline to online, trigger sync
  stream.listen((result) {
    if (result != ConnectivityResult.none) {
      // Trigger sync queue processing
      ref.read(syncServiceProvider).processQueue();
    }
  });
  
  return stream;
});
```

### Offline-aware repositories

Update `ScanRepository`, `ConversionRepository`, `TranslationRepository` to:
- Check `isOfflineProvider` before making Supabase calls
- If offline: enqueue the action via `syncService.enqueue()` + show `SnackBar`: `'You\'re offline — this will sync when you reconnect'` / `'Vous êtes hors ligne — cela se synchronisera à la reconnexion'`
- Always write to Drift immediately (optimistic local update)

Commit: `feat: offline sync queue — enqueue actions offline, process on reconnect`

Merge: `git checkout develop && git merge feature/offline-sync --no-ff`

---

## 12. Task 10 — Referral System (branch: `feature/referral`)

```bash
git checkout develop && git checkout -b feature/referral
```

### Supabase schema additions

Create `supabase/migrations/20240002_referral_system.sql`:

```sql
-- Add referral columns to profiles
ALTER TABLE public.profiles
ADD COLUMN IF NOT EXISTS referral_code TEXT UNIQUE,
ADD COLUMN IF NOT EXISTS referred_by TEXT,
ADD COLUMN IF NOT EXISTS bonus_scans INT NOT NULL DEFAULT 0;

-- Create referral code on profile insert (random 8-char uppercase alphanumeric)
CREATE OR REPLACE FUNCTION public.generate_referral_code()
RETURNS TRIGGER AS $$
BEGIN
  NEW.referral_code := UPPER(SUBSTRING(MD5(NEW.id::TEXT || EXTRACT(EPOCH FROM NOW())::TEXT) FROM 1 FOR 8));
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_referral_code
BEFORE INSERT ON public.profiles
FOR EACH ROW EXECUTE PROCEDURE public.generate_referral_code();

-- Referrals tracking table
CREATE TABLE IF NOT EXISTS public.referrals (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  referrer_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  referred_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  bonus_granted BOOLEAN DEFAULT FALSE
);

ALTER TABLE public.referrals ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users read own referrals" ON public.referrals
  FOR SELECT USING (auth.uid() = referrer_id);

-- Function to grant bonus scans when referral signs up and completes first scan
CREATE OR REPLACE FUNCTION public.grant_referral_bonus(referred_user_id UUID)
RETURNS VOID AS $$
DECLARE
  referrer UUID;
BEGIN
  SELECT referrer_id INTO referrer FROM public.referrals
  WHERE referred_id = referred_user_id AND bonus_granted = FALSE;
  
  IF referrer IS NOT NULL THEN
    -- Give referrer 2 bonus scans
    UPDATE public.profiles SET bonus_scans = bonus_scans + 2 WHERE id = referrer;
    -- Give referred user 2 bonus scans
    UPDATE public.profiles SET bonus_scans = bonus_scans + 2 WHERE id = referred_user_id;
    -- Mark bonus as granted
    UPDATE public.referrals SET bonus_granted = TRUE WHERE referred_id = referred_user_id;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

> 🔑 **DEVELOPER ACTION REQUIRED:**
> Run this migration SQL in Supabase SQL Editor.

### `lib/features/referral/data/referral_repository.dart`

```dart
// Get current user's referral code from profiles table
Future<String> getReferralCode(String userId)

// Apply a referral code during registration
// Looks up profile with matching referral_code
// Inserts to referrals table: referrer_id = found user, referred_id = current user
Future<bool> applyReferralCode(String code, String newUserId)

// Check how many referrals the user has made
Future<int> getReferralCount(String userId)

// Check and apply bonus after first scan completes
Future<void> checkAndGrantBonus(String userId)

// Get bonus scans remaining
Future<int> getBonusScans(String userId)
```

### Update quota logic

In `ScanRepository.canScan()`, update to include bonus scans:

```dart
// Free: 3 scans + bonus_scans from profiles
// Plus: unlimited
// Logic: (scans_used < 3 + bonus_scans) || isPlusUser
```

### UI additions

**In Register screen** — add optional referral code field below Confirm Password:
- `TextFormField` — optional, label: `'Referral code (optional)'` / `'Code de parrainage (facultatif)'`
- On register success: if referral code entered, call `referralRepository.applyReferralCode()`
- Show success chip: `'Referral applied! You\'ll both get 2 bonus scans after your first scan'` / `'Parrainage appliqué! Vous aurez tous les deux 2 analyses bonus après votre première analyse'`

**In Settings screen** — add `'Refer a Friend'` / `'Parrainer un ami'` section:

```
Card with vsAccent left border:
- Title: 'Your Referral Code' / 'Votre code de parrainage'
- Large text showing the code: 'AB3X9K7M' in monospace, vsPrimary, bold
- Subtitle: 'Share this code with friends. You both get 2 bonus scans when they complete their first scan.'
- 'Friends referred: 4' counter
- VsButton.primary('Share on WhatsApp') → share_plus with text:
    EN: "Join me on VeriScript — the best document tool for students and professionals in Cameroon! Use my referral code [CODE] and we both get 2 free bonus scans. Download: [Play Store link]"
    FR: "Rejoignez-moi sur VeriScript — le meilleur outil documentaire pour les étudiants et professionnels au Cameroun! Utilisez mon code de parrainage [CODE] et nous obtenons tous les deux 2 analyses gratuites bonus. Télécharger: [lien Play Store]"
- OutlinedButton('Copy Code') / 'Copier le code' → clipboard
```

**In Home quota bar** — if `bonus_scans > 0`, update display:
- `'2 of 3 scans used · +2 bonus'` / `'2 sur 3 analyses utilisées · +2 bonus'`

Commit: `feat: referral system — unique codes, WhatsApp sharing, bonus scan logic`

Merge: `git checkout develop && git merge feature/referral --no-ff`

---

## 13. Task 11 — Converter (Real CloudConvert) (branch: `feature/converter-live`)

```bash
git checkout develop && git checkout -b feature/converter-live
```

> 🔑 **DEVELOPER ACTION REQUIRED — Before Codex starts:**
> 1. Log into cloudconvert.com
> 2. Dashboard → API Keys → Create API Key
> 3. Scopes required: `task.read`, `task.write`
> 4. Run: `supabase secrets set CLOUDCONVERT_KEY=your_key`
> 5. Go to CloudConvert → Webhooks → Add webhook URL:
>    `https://YOUR_PROJECT_REF.supabase.co/functions/v1/cloudconvert-webhook`
> 6. Events to subscribe: `job.finished`, `job.failed`

Replace the simulated `convert-file` Edge Function with a real CloudConvert implementation:

### Updated `supabase/functions/convert-file/index.ts`

```typescript
// Real CloudConvert implementation:
//
// 1. Create a CloudConvert job:
//    POST https://api.cloudconvert.com/v2/jobs
//    Authorization: Bearer CLOUDCONVERT_KEY
//    Body: {
//      tasks: {
//        'import-file': { operation: 'import/url', url: signedStorageUrl },
//        'convert-file': {
//          operation: 'convert',
//          input: 'import-file',
//          input_format: fromFormat,
//          output_format: toFormat,
//        },
//        'export-file': { operation: 'export/url', input: 'convert-file' }
//      },
//      webhook_url: 'https://YOUR_PROJECT_REF.supabase.co/functions/v1/cloudconvert-webhook',
//      tag: jobId  // pass Supabase jobId as tag for webhook identification
//    }
//
// 2. Update conversion_jobs: status='processing', external_job_id=cloudconvert_job_id
//
// 3. Return { success: true, cloudConvertJobId }
//    (actual completion comes via webhook)
```

### New Edge Function — `supabase/functions/cloudconvert-webhook/index.ts`

```typescript
// Receives webhook from CloudConvert when job.finished or job.failed
// 
// Body: { job: { id, status, tag, tasks } }
// tag = our Supabase conversion_jobs.id
//
// On job.finished:
//   1. Find the export task in tasks array (operation: 'export/url')
//   2. Get the result.files[0].url — this is a temporary CloudConvert URL
//   3. Download the file from that URL
//   4. Upload to Supabase Storage 'processed' bucket at path: userId/jobId.toFormat
//   5. Update conversion_jobs: status='done', output_path=storagePath
//
// On job.failed:
//   Update conversion_jobs: status='failed'
```

Add `external_job_id` column to `conversion_jobs` table:

```sql
-- Add to supabase/migrations/20240003_conversion_external_id.sql
ALTER TABLE public.conversion_jobs ADD COLUMN IF NOT EXISTS external_job_id TEXT;
```

> 🔑 **DEVELOPER ACTION REQUIRED:**
> Run the migration SQL above in Supabase SQL Editor.
> Then deploy both functions:
> `supabase functions deploy convert-file`
> `supabase functions deploy cloudconvert-webhook`

No Flutter code changes needed — the Realtime subscription and UI from Phase 1 already handle the status updates correctly.

Commit: `feat: real CloudConvert integration replacing simulated Edge Function`

Merge: `git checkout develop && git merge feature/converter-live --no-ff`

---

## 14. Task 12 — ARB Updates (branch: `feature/i18n-p2`)

```bash
git checkout develop && git checkout -b feature/i18n-p2
```

Add all new strings to `lib/l10n/app_en.arb` and matching French translations to `lib/l10n/app_fr.arb`.

### New strings to add

```json
{
  "scannerTitle": "Plagiarism Check",
  "scannerUploadTitle": "Upload a Document",
  "scannerUploadSubtitle": "Scan against billions of sources",
  "scannerFileTypes": "PDF, DOCX or TXT · Max 10MB",
  "scannerDataWarning": "This may use significant mobile data",
  "scannerButton": "Scan for Plagiarism",
  "scannerChooseDifferent": "Choose different file",
  "scannerScansRemaining": "{used} of {max} scans used this month",
  "@scannerScansRemaining": { "placeholders": { "used": {"type": "int"}, "max": {"type": "int"} } },
  "scannerStatusUploading": "Uploading document...",
  "scannerStatusScanning": "Scanning against web sources...",
  "scannerStatusAcademic": "Checking academic databases...",
  "scannerStatusGenerating": "Generating your report...",
  "scannerStatusTime": "This usually takes 30–120 seconds",
  "scannerCancel": "Cancel",
  "scannerQuotaExceeded": "Scan limit reached for this month",
  "reportTitle": "Originality Report",
  "reportSimilarityScore": "Similarity Score",
  "reportLowRisk": "Low Risk — Likely Original",
  "reportMediumRisk": "Medium Risk — Review Required",
  "reportHighRisk": "High Risk — Significant Matches Found",
  "reportExportPdf": "Export PDF",
  "reportShare": "Share",
  "reportRescan": "Rescan",
  "reportMatchedSources": "Matched Sources",
  "reportNoSources": "No specific sources identified",
  "reportExportFailed": "Export failed. Try again.",
  "ocrTitle": "OCR Scanner",
  "ocrInfoTitle": "Scan any physical document",
  "ocrInfoSubtitle": "Works best with printed text, lecture notes, books, handouts",
  "ocrPrivacyNote": "On-device processing — nothing leaves your phone",
  "ocrTakePhoto": "Take Photo",
  "ocrChooseGallery": "Choose from Gallery",
  "ocrSupported": "Supported: Latin scripts, printed text in 50+ languages",
  "ocrProcessing": "Reading your document...",
  "ocrResultTitle": "Recognised Text",
  "ocrCopy": "Copy",
  "ocrTranslate": "Translate",
  "ocrConvert": "Convert",
  "ocrScanAgain": "Scan Again",
  "ocrNoText": "No text detected. Try better lighting or a clearer image.",
  "ocrCameraPermission": "Camera permission required",
  "translatorTitle": "Translator",
  "translatorAutoDetect": "Auto-detect",
  "translatorInputHint": "Enter text to translate...",
  "translatorButton": "Translate",
  "translatorOutputHint": "Translation will appear here",
  "translatorCharsUsed": "{used} / {max} chars used this month",
  "@translatorCharsUsed": { "placeholders": { "used": {"type": "int"}, "max": {"type": "int"} } },
  "translatorFromOcr": "From OCR Scanner",
  "translatorCopy": "Copy",
  "translatorCached": "⚡ Instant — from cache",
  "translatorQuotaExceeded": "Translation limit reached for this month",
  "translatorRecommended": "Recommended",
  "historyTitle": "History",
  "historySearch": "Search documents...",
  "historyFilterAll": "All",
  "historyFilterScans": "Scans",
  "historyFilterConversions": "Conversions",
  "historyFilterTranslations": "Translations",
  "historyFilterOcr": "OCR",
  "historyNewest": "Newest first",
  "historyOldest": "Oldest first",
  "historyEmpty": "No history yet",
  "historyEmptySubtitle": "Your processed documents will appear here",
  "historyDeleteConfirm": "Delete this document?",
  "historyUndo": "Undo",
  "historyLoadMore": "Load more",
  "driveTitle": "Google Drive",
  "driveConnect": "Connect Google Drive",
  "driveConnectSubtitle": "Import and export documents directly from your Drive",
  "driveConnectButton": "Connect with Google",
  "driveSignOut": "Disconnect Drive",
  "driveNoFiles": "No supported files found in Drive",
  "driveImport": "Import",
  "driveSaveToDrive": "Save to Drive",
  "driveSaveSuccess": "Saved to Drive",
  "notifyScanTitle": "Scan Complete",
  "notifyScanBody": "{documentName} — Similarity: {similarityPct}%",
  "@notifyScanBody": { "placeholders": { "documentName": {"type": "String"}, "similarityPct": {"type": "int"} } },
  "notifyConvertTitle": "Conversion Complete",
  "notifyConvertBody": "{documentName} converted to {format} successfully",
  "@notifyConvertBody": { "placeholders": { "documentName": {"type": "String"}, "format": {"type": "String"} } },
  "notifyTranslateTitle": "Translation Complete",
  "offlineSyncQueued": "You're offline — this will sync when you reconnect",
  "offlineSyncComplete": "Synced {count} documents from offline session",
  "@offlineSyncComplete": { "placeholders": { "count": {"type": "int"} } },
  "referralTitle": "Refer a Friend",
  "referralCodeLabel": "Your Referral Code",
  "referralSubtitle": "Share this code with friends. You both get 2 bonus scans when they complete their first scan.",
  "referralCount": "Friends referred: {count}",
  "@referralCount": { "placeholders": { "count": {"type": "int"} } },
  "referralShareButton": "Share on WhatsApp",
  "referralShareText": "Join me on VeriScript — the best document tool for students and professionals in Cameroon! Use my referral code {code} and we both get 2 free bonus scans. Download: https://play.google.com/store/apps/details?id=com.veriscipt.mobile",
  "@referralShareText": { "placeholders": { "code": {"type": "String"} } },
  "referralCopyCode": "Copy Code",
  "referralCodeCopied": "Code copied to clipboard",
  "referralCodeField": "Referral code (optional)",
  "referralApplied": "Referral applied! You'll both get 2 bonus scans after your first scan.",
  "referralInvalid": "Invalid referral code",
  "bonusScans": "+{count} bonus",
  "@bonusScans": { "placeholders": { "count": {"type": "int"} } }
}
```

After adding all strings, run:
```bash
flutter gen-l10n
```

Replace every hardcoded string in Phase 2 screens with the appropriate `AppLocalizations.of(context)!.keyName` call.

Commit: `feat: complete EN/FR ARB strings for all Phase 2 features`

Merge: `git checkout develop && git merge feature/i18n-p2 --no-ff`

---

## 15. Task 13 — Tests (branch: `feature/tests`)

```bash
git checkout develop && git checkout -b feature/tests
```

### Unit tests — `test/features/`

**`test/features/auth/auth_notifier_test.dart`:**
- `signInWithEmail` success → state is authenticated
- `signInWithEmail` with wrong password → state contains `InvalidCredentials` failure
- `signUpWithEmail` with duplicate email → `EmailAlreadyInUse` failure
- `sendPasswordReset` with valid email → no error
- Network timeout → `NetworkError` failure

**`test/features/scanner/scan_repository_test.dart`:**
- `canScan` returns true when scans_used < 3
- `canScan` returns false when scans_used >= 3 and no bonus scans
- `canScan` returns true with bonus scans even if base quota exceeded
- `incrementScanCount` increments correctly

**`test/features/translator/translation_repository_test.dart`:**
- Returns cached result when matching translation exists in Drift
- Calls Edge Function when no cache hit
- Correctly maps `charCount` to quota update

**`test/features/referral/referral_repository_test.dart`:**
- `applyReferralCode` with valid code → creates referral record
- `applyReferralCode` with invalid code → returns false
- `checkAndGrantBonus` → updates bonus_scans on both profiles

**`test/core/sync/sync_service_test.dart`:**
- `enqueue` writes to sync_queue_table
- `processQueue` calls correct repository method for each action type
- Failed items increment retry_count
- Items with retry_count >= 3 are marked 'failed', not deleted

### Widget tests — `test/widgets/`

**`test/widgets/vs_button_test.dart`:**
- Primary button renders with vsCta background
- Shows CircularProgressIndicator when `isLoading: true`
- Does not call `onPressed` when `isLoading: true`
- Secondary button has vsAccent border

**`test/widgets/vs_offline_banner_test.dart`:**
- Banner height is 0 when online
- Banner height is 40 when offline (after animation)

**`test/widgets/quota_bar_widget_test.dart`:**
- Bar colour is vsAccent when < 80% used
- Bar colour is vsWarning when 80–99% used
- Bar colour is vsError when 100% used
- Upgrade nudge visible when any bar is at 100%

### Integration test — `integration_test/`

**`integration_test/auth_flow_test.dart`:**

End-to-end with a Supabase test project (or mocked):
1. App launches → splash → onboarding (first time)
2. Tap `'Get Started Free'` → Register screen
3. Enter valid name, email, password → tap Register → success snackbar appears
4. Navigate to Login → enter credentials → tap Sign In → Home screen loads
5. Home screen shows 4 tool cards
6. Tap bottom nav → converter → converter screen loads
7. Sign out from settings → login screen shown

Run tests:
```bash
# Unit + widget tests
flutter test

# Integration test (emulator must be running)
flutter test integration_test/auth_flow_test.dart
```

Commit: `test: unit tests for auth, scanner, translator, referral, sync; widget tests; integration auth flow`

Merge: `git checkout develop && git merge feature/tests --no-ff`

---

## 16. Task 14 — Performance Pass (branch: `feature/performance`)

```bash
git checkout develop && git checkout -b feature/performance
```

Profile with Flutter DevTools. Fix every issue found. Key areas:

### Home Dashboard scroll performance

- Wrap the `CustomScrollView` sliver content in `RepaintBoundary` widgets around the quota bar, tool grid, and recent docs list
- Ensure tool card images/icons are not rebuilding on every scroll
- Use `const` constructors everywhere possible in static widgets

### History list performance

- Use `ListView.builder` — never `ListView` with children (already specified but verify)
- Wrap each `HistoryItem` card in `RepaintBoundary`
- Ensure `Dismissible` key is always the document ID (stable key)
- Test with 50+ items — scroll must be 60fps

### Drift query optimisation

- Add indexes to frequently queried columns if missing:

```sql
-- Add to a new migration file
CREATE INDEX IF NOT EXISTS idx_documents_user_created ON public.documents(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_scan_reports_user_created ON public.scan_reports(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_translations_user ON public.translations(user_id);
```

- In `DocumentsDao`, ensure `getRecentDocuments` uses `LIMIT` and an index

### Cold start time

- Move all heavy initialisation out of `main()` into lazy providers
- Only Supabase.initialize and Sentry.init in `main()`
- Everything else initialises on first use via Riverpod providers

### Image and Lottie

- Replace Lottie placeholder JSONs with real, optimised Lottie files (< 50KB each)
- Set `Lottie(frameRate: FrameRate.max)` only on splash — all others use `FrameRate(30)`

### Build size

Run and log the output:
```bash
flutter build apk --analyze-size
```

If APK > 25MB, identify large assets or packages and document in a `PERFORMANCE_NOTES.md`.

Commit: `perf: RepaintBoundary, const constructors, Drift indexes, cold start optimisation`

Merge: `git checkout develop && git merge feature/performance --no-ff`

---

## 17. Task 15 — Final Merge + Beta Tag

```bash
git checkout develop
```

Run all of these in order. Each must pass before moving to the next:

```bash
# 1. Get packages
flutter pub get

# 2. Generate all code
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Generate l10n
flutter gen-l10n

# 4. Run all tests
flutter test

# 5. Analyse — must show 0 errors (warnings acceptable)
flutter analyze

# 6. Run on emulator with placeholder credentials
flutter run \
  --dart-define=SUPABASE_URL=https://placeholder.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=placeholder \
  --dart-define=SENTRY_DSN=placeholder
```

**Expected complete app behaviour:**
- Splash → Onboarding → Register → Login → Home (all working from Phase 1)
- Home quota bars show shimmer then real data
- Plagiarism scanner: file pick → upload → scanning states → result screen with ring chart and sources
- OCR: camera permission → capture → ML Kit processing → recognised text with translate/convert actions
- Translator: text input → language selection → translation output → cache badge on repeat
- Converter: file pick → format selection → upload → CloudConvert processing → download (with real key) or done state (with placeholder)
- History: list of all actions, search, filter, swipe delete, pull-to-refresh
- Google Drive: sign in → file list → import
- Notifications: appear when scan/conversion complete in background
- Settings: language toggle, referral code section, Drive disconnect
- Offline: banner appears, actions queued, sync on reconnect

### Update `PHASE1_SUMMARY.md` → rename to `BUILD_HISTORY.md`

Document:
- Phase 1 branches and features
- Phase 2 branches and features
- All `🔑 DEVELOPER ACTION REQUIRED` items and their status
- All remaining `// TODO` comments in the codebase
- Steps to run with real credentials

### Final git commands

```bash
git add .
git commit -m "chore: Phase 2 complete — all features integrated and tested"

git checkout main
git merge develop --no-ff
git tag -a v0.2.0-beta -m "Phase 2 Beta: Scanner, OCR, Translator, History, Drive, Referrals, Offline Sync"
git push origin main --tags
git push origin develop
```

---

## 18. Gemini Android Studio Instructions

Use Gemini in Android Studio for these tasks alongside Codex. Do not ask Gemini to change folder architecture.

| After Codex merges | Ask Gemini |
|---|---|
| `feature/edge-functions` | Review the Edge Function TypeScript for `scan-document` and suggest error handling improvements for Copyleaks API timeout |
| `feature/scanner` | Write widget tests for `ScannerScreen` covering the 3 UI states (idle, scanning, quota exceeded) |
| `feature/report` | Review `ScanResultScreen` and suggest performance improvements for the source list with 50+ sources |
| `feature/ocr` | Review `OcrService` and confirm ML Kit is being disposed correctly to prevent memory leaks |
| `feature/translator` | Review the debounce implementation in `TranslatorNotifier` and suggest improvements |
| `feature/history-sync` | Review pagination implementation and suggest improvements for very large history lists |
| `feature/offline-sync` | Review `SyncService.processQueue()` and suggest improvements for handling concurrent sync requests |
| `feature/referral` | Review the referral SQL functions and suggest index improvements |
| `feature/tests` | Review test coverage report and identify any critical paths not covered |
| `feature/performance` | Run Flutter DevTools on the history list and identify any remaining jank sources |

**For AndroidManifest.xml additions (Phase 2), ask Gemini:**
> "Phase 2 added: google_sign_in (Drive scope), workmanager, permission_handler. Update `android/app/src/main/AndroidManifest.xml` to add all required permissions, the WorkManager initialiser, and any intent filters needed for Google Sign-In callback. Keep changes minimal."

---

## 19. Developer Action Checklist

These are all the things **you** need to do — Codex cannot do them. Work through this list alongside the Codex tasks.

| # | Action | When | Where |
|---|---|---|---|
| 1 | Add Copyleaks API key to Supabase secrets | Before Task 1 | Terminal: `supabase secrets set` |
| 2 | Add CloudConvert API key to Supabase secrets | Before Task 1 | Terminal: `supabase secrets set` |
| 3 | Add Google Translate API key to Supabase secrets | Before Task 1 | Terminal: `supabase secrets set` |
| 4 | Add Supabase Service Role Key to secrets | Before Task 1 | Terminal: `supabase secrets set` |
| 5 | Run migration: `add_external_scan_id.sql` | Before Task 2 | Supabase SQL Editor |
| 6 | Set Copyleaks webhook URL | After Task 1 deploy | Copyleaks Dashboard |
| 7 | Deploy all Edge Functions | After Task 1 | Terminal: `supabase functions deploy` |
| 8 | Enable Google Drive API in Google Cloud Console | Before Task 7 | console.cloud.google.com |
| 9 | Create Android OAuth credentials + add SHA-1 | Before Task 7 | Google Cloud Console |
| 10 | Download `google-services.json` → `android/app/` | Before Task 7 | Google Cloud Console |
| 11 | Run migration: `referral_system.sql` | Before Task 10 | Supabase SQL Editor |
| 12 | Create CloudConvert API key with correct scopes | Before Task 11 | cloudconvert.com |
| 13 | Set CloudConvert webhook URL | After Task 11 deploy | CloudConvert Dashboard |
| 14 | Deploy `convert-file` + `cloudconvert-webhook` | After Task 11 | Terminal: `supabase functions deploy` |
| 15 | Run migration: `conversion_external_id.sql` | Before Task 11 | Supabase SQL Editor |
| 16 | Replace placeholder Lottie JSONs with real ones | During Task 14 | lottiefiles.com → `assets/animations/` |
| 17 | Update WhatsApp number in referral share text | Before beta | `home_screen.dart` + `settings_screen.dart` |
| 18 | Update Play Store URL in ARB files | Before beta | `app_en.arb` + `app_fr.arb` |

---

## 20. Phase 3 Preview

When `v0.2.0-beta` is tagged and beta testing with real users is underway, Phase 3 covers:

| Feature | Detail |
|---|---|
| **Payment screen** | MTN MoMo + Orange Money manual flow + RevenueCat Play Billing |
| **VeriScript Plus paywall** | Pricing screen, entitlement gating, XAF pricing display |
| **FCM push notifications** | Server-triggered (not local) — scan complete even when app killed |
| **iOS build** | Xcode signing, App Store listing, TestFlight beta |
| **Batch file processing** | Multiple files at once — Plus feature |
| **Document editor** | Basic in-app text editing for TXT outputs |
| **Admin dashboard** | Supabase-powered stats: scans/day, active users, conversion volume |
| **App Store / Play Store launch** | Staged rollout 10% → 50% → 100% |

---

*VeriScript Phase 2 · Flutter + Supabase · Built for Cameroon*
