# VeriScript Mobile — Codex Phase 1 Build Instructions

> **For Codex:** Read this entire file before writing a single line of code.
> Work through every section in order. One branch per feature. Commit after each task.
> No payment, no RevenueCat, no iOS-specific code in this phase.

---

## Table of Contents

1. [Project Context](#1-project-context)
2. [Tech Stack](#2-tech-stack)
3. [Git Branching Rules](#3-git-branching-rules)
4. [Task 1 — pubspec.yaml + Asset Folders](#4-task-1--pubspecyaml--asset-folders)
5. [Task 2 — Folder Structure](#5-task-2--folder-structure)
6. [Task 3 — Material 3 Theme](#6-task-3--material-3-theme-branch-featuretheme)
7. [Task 4 — Supabase Init + main.dart](#7-task-4--supabase-init--maindart-branch-featuresupabase-init)
8. [Task 5 — Navigation Shell](#8-task-5--navigation-shell-branch-featurenavigation)
9. [Task 6 — Splash Screen](#9-task-6--splash-screen-branch-featuresplash)
10. [Task 7 — Onboarding Flow](#10-task-7--onboarding-flow-branch-featureonboarding)
11. [Task 8 — Auth Screens](#11-task-8--auth-screens-branch-featureauth)
12. [Task 9 — Home Dashboard](#12-task-9--home-dashboard-branch-featurehome)
13. [Task 10 — File Converter UI](#13-task-10--file-converter-ui-branch-featureconverter)
14. [Task 11 — Drift Local DB](#14-task-11--drift-local-db-branch-featurelocal-db)
15. [Task 12 — Shared Widgets + i18n](#15-task-12--shared-widgets--i18n-branch-featurei18n)
16. [Task 13 — Stub Screens](#16-task-13--stub-screens-branch-featurestubs)
17. [Task 14 — Final Merge + Verification](#17-task-14--final-merge--verification)
18. [Gemini (Android Studio) Instructions](#18-gemini-android-studio-instructions)
19. [Phase 2 Preview](#19-phase-2-preview)

---

## 1. Project Context

**VeriScript** is a cross-platform Flutter + Supabase document productivity app.

### What it does

- Scan documents for plagiarism (Copyleaks API via Supabase Edge Function)
- Convert files between PDF, DOCX, and TXT (CloudConvert API via Supabase Edge Function)
- Scan physical documents with phone camera using on-device OCR (Google ML Kit)
- Translate documents into 100+ languages (Google Cloud Translate via Supabase Edge Function)
- Sync documents with Google Drive
- Access all processed documents offline

### Primary market — Cameroon

This shapes every UX decision. Codex must implement these realities:

| Market Reality | How it affects VeriScript |
|---|---|
| **Mobile Money dominant** | No payment UI in Phase 1. Payment screen is Phase 3. |
| **Expensive mobile data** | Show file sizes before upload. Never auto-load full documents. Cache aggressively. |
| **Students are core users** | Plagiarism detection is the #1 reason to download. Semester deadlines = peak usage. |
| **French + English bilingual** | ALL strings go in ARB files. Never hardcode English. Default to device locale. |
| **Intermittent connectivity** | Offline-first. Every feature must degrade gracefully. Show offline banner. |
| **Android-first** | 99%+ of Cameroon users are on Android. No iOS code in Phase 1. |
| **WhatsApp = distribution** | WhatsApp share button on Home screen is high-priority. |

### Credentials — use these exact placeholders

```
SUPABASE_URL        → https://YOUR_PROJECT_REF.supabase.co
SUPABASE_ANON_KEY   → YOUR_SUPABASE_ANON_KEY
SENTRY_DSN          → YOUR_SENTRY_DSN
```

All secrets are injected via `--dart-define-from-file=.env.local`. Never hardcode them. Never commit `.env.local`.

---

## 2. Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.22.x / Dart 3.4.x |
| Backend | Supabase (Auth · PostgreSQL · Storage · Edge Functions · Realtime) |
| State management | Riverpod 2.x (`flutter_riverpod`, `riverpod_annotation`) |
| Navigation | `go_router` 13.x |
| Local DB | Drift (SQLite) |
| HTTP client | Dio 5.x |
| OCR | Google ML Kit (on-device, no network) |
| Fonts | Inter via `google_fonts` |
| Charts | `fl_chart` |
| Animations | Lottie |
| Monitoring | Sentry |
| i18n | Flutter ARB / `flutter_localizations` |

**No RevenueCat. No payment code. No iOS-specific code in Phase 1.**

---

## 3. Git Branching Rules

> These rules are mandatory. Do not skip them.

```
main        ← production only. Never commit directly.
develop     ← integration branch. All features merge here.
feature/xxx ← one branch per task, cut from develop.
```

### Branch workflow for every task

```bash
# Before starting any task:
git checkout develop
git checkout -b feature/task-name

# After completing any task:
git checkout develop
git merge feature/task-name --no-ff
git push origin develop
```

### Commit message format (Conventional Commits)

```
feat:   new feature
chore:  setup, config, tooling
fix:    bug fix
style:  formatting only
refactor: code change without behaviour change
test:   adding tests
```

### Initial branch setup — run this first

```bash
git checkout main
git pull origin main
git checkout -b develop
git push -u origin develop
```

Then add `.env.local` to `.gitignore`:

```
.env.local
.env.*.local
*.env
/build
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
pubspec.lock
```

> Keep `pubspec.lock` — we DO want to commit it.
> Correct the `.gitignore` above: remove `pubspec.lock` from ignore list.

Commit: `chore: git branching setup and gitignore`

---

## 4. Task 1 — pubspec.yaml + Asset Folders

**Branch:** `develop` (this task runs directly on develop before branching)

### pubspec.yaml

Replace the entire file with:

```yaml
name: veriscipt_mobile
description: Document integrity and utility suite for students and professionals
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # Backend
  supabase_flutter: ^2.5.0

  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^13.2.0

  # Data models
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0

  # Networking
  dio: ^5.4.3

  # Security
  flutter_secure_storage: ^9.2.2

  # File & Camera
  file_picker: ^8.0.6
  camera: ^0.10.5+9
  google_mlkit_text_recognition: ^0.13.0

  # Google Sign-In (for Drive integration)
  google_sign_in: ^6.2.1

  # Local DB
  drift: ^2.19.1
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.4
  path: ^1.9.0

  # Preferences
  shared_preferences: ^2.3.0

  # UI
  fl_chart: ^0.68.0
  lottie: ^3.1.2
  cached_network_image: ^3.3.1
  google_fonts: ^6.2.1
  share_plus: ^9.0.0
  flutter_local_notifications: ^17.2.3
  connectivity_plus: ^6.0.3
  shimmer: ^3.0.0
  percent_indicator: ^4.2.3

  # Monitoring
  sentry_flutter: ^7.18.0

  # i18n
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.9
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  riverpod_generator: ^2.4.0
  drift_dev: ^2.19.1
  mockito: ^5.4.4
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  generate: true
  assets:
    - assets/animations/
    - assets/images/
    - assets/fonts/
```

After writing the file, run:

```bash
flutter pub get
```

It must complete with no errors.

### Asset folders

Create these folders with a `.gitkeep` file in each:

```
assets/animations/
assets/images/
assets/fonts/
```

Create placeholder Lottie JSON files (replace with real ones from lottiefiles.com later):

**`assets/animations/splash.json`**
**`assets/animations/loading.json`**
**`assets/animations/empty.json`**

Each placeholder content:
```json
{
  "placeholder": true,
  "note": "Replace with real Lottie JSON from lottiefiles.com",
  "v": "5.5.7",
  "fr": 30,
  "ip": 0,
  "op": 60,
  "w": 200,
  "h": 200,
  "layers": []
}
```

### l10n config

Create `l10n.yaml` at the project root:

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

Commit: `chore: pubspec dependencies, asset folders, and l10n config`

---

## 5. Task 2 — Folder Structure

**Branch:** `develop`

Create every file listed below. Each Dart file should contain only a comment `// TODO: implement` and the correct class/function signature stub. Do not leave any file completely empty — Dart files need at minimum a valid library or class declaration.

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_component_themes.dart
│   │   └── app_theme.dart
│   │
│   ├── router/
│   │   ├── app_routes.dart
│   │   ├── auth_guard.dart
│   │   └── app_router.dart
│   │
│   ├── supabase/
│   │   └── supabase_providers.dart
│   │
│   ├── network/
│   │   ├── dio_client.dart
│   │   └── edge_function_caller.dart
│   │
│   ├── local_db/
│   │   ├── app_database.dart
│   │   ├── tables/
│   │   │   ├── documents_table.dart
│   │   │   ├── scan_reports_table.dart
│   │   │   ├── translations_table.dart
│   │   │   └── conversion_jobs_table.dart
│   │   └── daos/
│   │       ├── documents_dao.dart
│   │       ├── scan_reports_dao.dart
│   │       └── translations_dao.dart
│   │
│   ├── providers/
│   │   ├── connectivity_provider.dart
│   │   └── auth_state_provider.dart
│   │
│   └── widgets/
│       ├── vs_button.dart
│       ├── vs_card.dart
│       ├── vs_loading.dart
│       ├── vs_empty_state.dart
│       ├── vs_error_view.dart
│       ├── vs_offline_banner.dart
│       └── vs_app_bar.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   ├── domain/
│   │   │   └── auth_failure.dart
│   │   └── presentation/
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       ├── forgot_password_screen.dart
│   │       └── auth_notifier.dart
│   │
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── onboarding_screen.dart
│   │       └── onboarding_page_model.dart
│   │
│   ├── splash/
│   │   └── presentation/
│   │       └── splash_screen.dart
│   │
│   ├── home/
│   │   ├── data/
│   │   │   └── quota_repository.dart
│   │   └── presentation/
│   │       ├── home_screen.dart
│   │       ├── tool_card_widget.dart
│   │       └── quota_bar_widget.dart
│   │
│   ├── converter/
│   │   ├── data/
│   │   │   └── conversion_repository.dart
│   │   ├── domain/
│   │   │   └── conversion_job.dart
│   │   └── presentation/
│   │       ├── converter_screen.dart
│   │       └── converter_notifier.dart
│   │
│   ├── scanner/
│   │   └── presentation/
│   │       └── scanner_screen.dart
│   │
│   ├── ocr/
│   │   └── presentation/
│   │       └── ocr_screen.dart
│   │
│   ├── translator/
│   │   └── presentation/
│   │       └── translator_screen.dart
│   │
│   └── history/
│       └── presentation/
│           └── history_screen.dart
│
└── l10n/
    ├── app_en.arb
    └── app_fr.arb
```

Commit: `chore: scaffold complete feature-first folder structure`

---

## 6. Task 3 — Material 3 Theme (branch: `feature/theme`)

```bash
git checkout develop && git checkout -b feature/theme
```

### `lib/core/theme/app_colors.dart`

```dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color vsPrimary        = Color(0xFF1A3C5E); // Deep Navy
  static const Color vsAccent         = Color(0xFF2BBFAA); // Teal Mint
  static const Color vsCta            = Color(0xFFF4A300); // Amber Gold
  static const Color vsDark           = Color(0xFF0F1E2D); // Midnight
  static const Color vsBackground     = Color(0xFFF0F6FB); // Ice Blue
  static const Color vsSurface        = Color(0xFFFFFFFF); // White
  static const Color vsGray           = Color(0xFF6B7C8D); // Steel Gray
  static const Color vsError          = Color(0xFFE53935); // Alert Red
  static const Color vsSuccess        = Color(0xFF43A047); // Verified Green
  static const Color vsWarning        = Color(0xFFFB8C00); // Amber Orange
  static const Color vsHighSimilarity = Color(0xFFE53935); // >70% match
  static const Color vsMedSimilarity  = Color(0xFFFB8C00); // 30–70% match
  static const Color vsLowSimilarity  = Color(0xFF43A047); // <30% match
  static const Color vsLightGray      = Color(0xFFEAF0F6); // Light bg
}
```

### `lib/core/theme/app_text_styles.dart`

Use `google_fonts` Inter. Define named constants for all 6 type roles:
- `displayLarge` — Inter Bold, 57sp
- `headlineMedium` — Inter SemiBold, 28sp
- `titleLarge` — Inter Medium, 22sp
- `bodyLarge` — Inter Regular, 16sp
- `bodySmall` — Inter Regular, 14sp
- `labelSmall` — Inter Medium, 11sp

### `lib/core/theme/app_component_themes.dart`

Define all component theme overrides as static getters:

**ElevatedButtonThemeData:**
- backgroundColor → `vsCta`
- foregroundColor → `vsDark`
- shape → `RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))`
- minimumSize → `Size(double.infinity, 52)`
- textStyle → Inter SemiBold 16sp

**OutlinedButtonThemeData:**
- side → `BorderSide(color: AppColors.vsAccent, width: 1.5)`
- foregroundColor → `vsAccent`
- shape → radius 12

**CardTheme:**
- color → `vsSurface`
- elevation → 2
- shape → radius 16
- margin → `EdgeInsets.zero`

**AppBarTheme:**
- backgroundColor → `vsPrimary`
- foregroundColor → white
- elevation → 0
- centerTitle → false

**NavigationBarTheme (Material 3 bottom nav):**
- indicatorColor → `vsAccent` with opacity 0.2
- iconTheme for selected → `vsAccent`
- iconTheme for unselected → `vsGray`
- backgroundColor → `vsSurface`
- labelTextStyle for selected → Inter Medium 12sp `vsAccent`

**InputDecorationTheme:**
- filled → true
- fillColor → `vsBackground`
- border → `OutlineInputBorder(borderRadius: 12, borderSide: vsGray)`
- focusedBorder → `OutlineInputBorder(borderRadius: 12, borderSide: vsAccent width 2)`
- contentPadding → `EdgeInsets.symmetric(horizontal: 16, vertical: 14)`

### `lib/core/theme/app_theme.dart`

```dart
static ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.vsPrimary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.vsPrimary,
    secondary: AppColors.vsAccent,
    tertiary: AppColors.vsCta,
    background: AppColors.vsBackground,
    surface: AppColors.vsSurface,
    error: AppColors.vsError,
  ),
  fontFamily: GoogleFonts.inter().fontFamily,
  textTheme: AppTextStyles.textTheme,
  elevatedButtonTheme: AppComponentThemes.elevatedButton,
  outlinedButtonTheme: AppComponentThemes.outlinedButton,
  cardTheme: AppComponentThemes.card,
  appBarTheme: AppComponentThemes.appBar,
  navigationBarTheme: AppComponentThemes.navigationBar,
  inputDecorationTheme: AppComponentThemes.inputDecoration,
  scaffoldBackgroundColor: AppColors.vsBackground,
);
```

Commit: `feat: Material 3 VeriScript theme — colors, typography, component themes`

Merge: `git checkout develop && git merge feature/theme --no-ff`

---

## 7. Task 4 — Supabase Init + main.dart (branch: `feature/supabase-init`)

```bash
git checkout develop && git checkout -b feature/supabase-init
```

### `lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
      options.tracesSampleRate = 1.0;
    },
    appRunner: () async {
      await Supabase.initialize(
        url: const String.fromEnvironment('SUPABASE_URL'),
        anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
      );
      runApp(const ProviderScope(child: VeriScriptApp()));
    },
  );
}
```

### `lib/app.dart`

`VeriScriptApp` extends `ConsumerWidget`:
- Reads `appRouterProvider` from `core/router/app_router.dart`
- Returns `MaterialApp.router` with:
  - `routerConfig: ref.watch(appRouterProvider)`
  - `title: 'VeriScript'`
  - `theme: AppTheme.lightTheme`
  - `localizationsDelegates: AppLocalizations.localizationsDelegates`
  - `supportedLocales: AppLocalizations.supportedLocales`
  - `locale: ref.watch(localeProvider)`

### `lib/core/supabase/supabase_providers.dart`

```dart
final supabaseClientProvider = Provider(
  (ref) => Supabase.instance.client,
);

final supabaseStorageProvider = Provider(
  (ref) => Supabase.instance.client.storage,
);
```

### `lib/core/providers/auth_state_provider.dart`

```dart
final authStateProvider = StreamProvider((ref) {
  return ref.watch(supabaseClientProvider).auth.onAuthStateChange;
});
```

### `lib/core/providers/connectivity_provider.dart`

Use `connectivity_plus` to expose a `StreamProvider<ConnectivityResult>` called `connectivityProvider`. Also expose a `Provider<bool>` called `isOfflineProvider` that returns `true` when connectivity is `none`.

### `lib/core/providers/locale_provider.dart`

```dart
// StateProvider<Locale> that:
// 1. Reads SharedPreferences 'app_locale' key on first access
// 2. Defaults to device locale: if starts with 'fr' → Locale('fr'), else Locale('en')
// 3. Persists changes back to SharedPreferences
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
```

Commit: `feat: Supabase init, Riverpod providers, locale and connectivity providers`

Merge: `git checkout develop && git merge feature/supabase-init --no-ff`

---

## 8. Task 5 — Navigation Shell (branch: `feature/navigation`)

```bash
git checkout develop && git checkout -b feature/navigation
```

### `lib/core/router/app_routes.dart`

```dart
class AppRoutes {
  AppRoutes._();

  static const String splash          = '/';
  static const String onboarding      = '/onboarding';
  static const String login           = '/auth/login';
  static const String register        = '/auth/register';
  static const String forgotPassword  = '/auth/forgot-password';
  static const String home            = '/home';
  static const String scanner         = '/scanner';
  static const String converter       = '/converter';
  static const String ocr             = '/ocr';
  static const String translator      = '/translator';
  static const String history         = '/history';
  static const String settings        = '/settings';
}
```

### `lib/core/router/auth_guard.dart`

Create a `redirect` function for GoRouter:
- If `currentSession == null` and path is NOT in `[splash, onboarding, login, register, forgotPassword]` → redirect to `/auth/login`
- If `currentSession != null` and path starts with `/auth/` → redirect to `/home`
- If path is `/` (splash) → return null (splash handles its own redirect)
- Otherwise → return null (no redirect)

### `lib/core/router/app_router.dart`

Create `appRouterProvider` as `Provider<GoRouter>`:

**Top-level routes (no shell):**
- `/` → `SplashScreen`
- `/onboarding` → `OnboardingScreen`
- `/auth/login` → `LoginScreen`
- `/auth/register` → `RegisterScreen`
- `/auth/forgot-password` → `ForgotPasswordScreen`

**Shell route with `NavigationBar` (Material 3) for the 5 main destinations:**

```
/home         → HomeScreen          icon: Icons.home_rounded
/scanner      → ScannerScreen       icon: Icons.document_scanner_rounded
/converter    → ConverterScreen     icon: Icons.swap_horiz_rounded
/history      → HistoryScreen       icon: Icons.history_rounded
/settings     → SettingsScreen (stub) icon: Icons.settings_rounded
```

**GoRouterRefreshStream:** Create a `ChangeNotifier` wrapper around `Supabase.instance.client.auth.onAuthStateChange` and pass it to `GoRouter(refreshListenable:)`.

**Settings screen stub** — create `lib/features/settings/presentation/settings_screen.dart`:
```dart
// Simple scaffold with AppBar and a language toggle ListTile
// ListTile title: 'Language / Langue'
// Trailing: SegmentedButton with [EN, FR] segments
// On change: update localeProvider and persist to SharedPreferences
```

Commit: `feat: go_router navigation shell with Material 3 NavigationBar and auth guard`

Merge: `git checkout develop && git merge feature/navigation --no-ff`

---

## 9. Task 6 — Splash Screen (branch: `feature/splash`)

```bash
git checkout develop && git checkout -b feature/splash
```

### `lib/features/splash/presentation/splash_screen.dart`

**Visual spec:**
- Scaffold with `vsBackground` background
- Centered `Column` with `MainAxisAlignment.center`
- `Lottie.asset('assets/animations/splash.json', width: 200, height: 200, repeat: false)`
- `SizedBox(height: 24)`
- `Text('VeriScript')` — `headlineMedium`, `vsPrimary`, bold
- `Container(width: 60, height: 3, color: vsAccent)` — accent underline
- `SizedBox(height: 8)`
- `Text('Document Integrity Suite')` — `bodySmall`, `vsGray`, italic
  - French: `'Suite d\'intégrité documentaire'`

**Behaviour (in `initState`):**
1. Play animation
2. After 2800ms, check:
   - `Supabase.instance.client.auth.currentSession != null` → `context.go(AppRoutes.home)`
   - Else check `SharedPreferences.getBool('onboarding_done')` — if null or false → `context.go(AppRoutes.onboarding)`
   - Else → `context.go(AppRoutes.login)`

Commit: `feat: animated splash screen with Lottie and auth-aware redirect`

Merge: `git checkout develop && git merge feature/splash --no-ff`

---

## 10. Task 7 — Onboarding Flow (branch: `feature/onboarding`)

```bash
git checkout develop && git checkout -b feature/onboarding
```

### `lib/features/onboarding/presentation/onboarding_page_model.dart`

```dart
class OnboardingPageModel {
  final String lottieAsset;
  final String titleKey;   // ARB key
  final String bodyKey;    // ARB key
  const OnboardingPageModel({required this.lottieAsset, required this.titleKey, required this.bodyKey});
}
```

### `lib/features/onboarding/presentation/onboarding_screen.dart`

**3 slides:**

| Slide | Lottie | Title (EN) | Title (FR) | Body (EN) | Body (FR) |
|---|---|---|---|---|---|
| 1 | `splash.json` | Check for Plagiarism Instantly | Détectez le plagiat instantanément | Scan any document against billions of sources. Get detailed reports in seconds. | Analysez tout document contre des milliards de sources. Obtenez des rapports en quelques secondes. |
| 2 | `loading.json` | Convert, Translate & Scan | Convertissez, Traduisez et Numérisez | PDF to Word, 100+ language translation, and OCR scanning — all in one app. | PDF vers Word, traduction en 100+ langues, numérisation OCR — tout en une application. |
| 3 | `empty.json` | Built for Students in Cameroon | Conçu pour les étudiants au Cameroun | Join thousands of students at universities across Cameroon. Start free today. | Rejoignez des milliers d'étudiants dans les universités du Cameroun. Commencez gratuitement. |

**UX requirements:**
- `PageView` with `PageController`
- Dot indicators: active → `vsAccent`, inactive → `vsGray`
- `Skip` `TextButton` top-right on slides 1 and 2
- `Next` `TextButton` bottom-right on slides 1 and 2
- On slide 3: show two buttons:
  - `ElevatedButton` — `'Get Started Free'` / `'Commencer gratuitement'` → saves `SharedPreferences 'onboarding_done' = true` → `context.go(AppRoutes.register)`
  - `TextButton` — `'Already have an account? Sign in'` / `'Déjà un compte? Se connecter'` → `context.go(AppRoutes.login)`
- Skip and Next also save `onboarding_done = true` before navigating

Commit: `feat: 3-slide bilingual onboarding with Cameroon-specific copy`

Merge: `git checkout develop && git merge feature/onboarding --no-ff`

---

## 11. Task 8 — Auth Screens (branch: `feature/auth`)

```bash
git checkout develop && git checkout -b feature/auth
```

### `lib/features/auth/domain/auth_failure.dart`

Sealed class with these cases:
- `InvalidCredentials` — `'Invalid email or password'` / `'Email ou mot de passe invalide'`
- `EmailAlreadyInUse` — `'An account already exists with this email'` / `'Un compte existe déjà avec cet email'`
- `WeakPassword` — `'Password must be at least 8 characters'` / `'Le mot de passe doit comporter au moins 8 caractères'`
- `NetworkError` — `'No connection. Check your internet.'` / `'Pas de connexion. Vérifiez votre internet.'`
- `Unknown` — `'Something went wrong. Please try again.'` / `'Quelque chose s\'est mal passé. Veuillez réessayer.'`

Each case has a `message(Locale locale)` method returning the appropriate string.

### `lib/features/auth/data/auth_repository.dart`

Methods — all call Supabase Auth and map `AuthException` to `AuthFailure`:
- `signInWithEmail(String email, String password)`
- `signUpWithEmail(String email, String password, String displayName)` — after sign-up, insert to `public.profiles`
- `signOut()`
- `sendPasswordReset(String email)`

### `lib/features/auth/presentation/auth_notifier.dart`

`AsyncNotifier` that wraps the repository. Each method sets the notifier to loading, calls the repo, handles errors by mapping to `AuthFailure`.

### `lib/features/auth/presentation/login_screen.dart`

**Layout:**
- `vsBackground` scaffold
- Centered scrollable `Column`
- Top: `Text('VeriScript')` in `headlineMedium` + `vsPrimary` — acts as logo
- `SizedBox(height: 8)`
- `Container(width: 50, height: 3, color: vsAccent)` — brand accent line
- `SizedBox(height: 32)`
- White `Card` (elevation 2, radius 16, padding 24) containing:
  - `Text('Welcome back')` / `'Bon retour'` in `titleLarge`
  - `SizedBox(height: 24)`
  - Email `TextFormField` — validate: non-empty, valid email
  - `SizedBox(height: 16)`
  - Password `TextFormField` — obscured, suffix `IconButton` to toggle visibility
  - `SizedBox(height: 8)`
  - `TextButton` — `'Forgot password?'` / `'Mot de passe oublié?'` → `context.push(AppRoutes.forgotPassword)`
  - `SizedBox(height: 8)`
  - `ElevatedButton` — `'Sign In'` / `'Se connecter'` → calls `authNotifier.signInWithEmail`
    - Show `CircularProgressIndicator` inside button while loading
  - `SizedBox(height: 16)`
  - `Row` with `Divider` + `Text('OR' / 'OU')` + `Divider`
  - `SizedBox(height: 16)`
  - `OutlinedButton` — `'Create account'` / `'Créer un compte'` → `context.push(AppRoutes.register)`

**Behaviour:**
- On success: `GoRouter` refreshes via `authStateProvider` → auto-redirects to `/home`
- On error: `ScaffoldMessenger.showSnackBar` with `authFailure.message(locale)` in red

### `lib/features/auth/presentation/register_screen.dart`

Fields: Full Name, Email, Password, Confirm Password.

Password strength indicator below password field:
- Weak (< 8 chars) → red thin `LinearProgressIndicator`, value 0.33
- Medium (8+ chars, some variety) → orange, value 0.66
- Strong (8+, uppercase + number + special) → green, value 1.0

Terms checkbox: `'I agree to the Terms of Service'` / `'J\'accepte les conditions d\'utilisation'` — register button is disabled until checked.

On success: `SnackBar` — `'Check your email to confirm your account'` / `'Vérifiez votre email pour confirmer votre compte'`

### `lib/features/auth/presentation/forgot_password_screen.dart`

Single email field + `'Send Reset Link'` / `'Envoyer le lien'` button.
On success: `SnackBar` success message, disable button for 60 seconds to prevent spam.

Commit: `feat: complete auth flow — login, register, forgot password, bilingual errors`

Merge: `git checkout develop && git merge feature/auth --no-ff`

---

## 12. Task 9 — Home Dashboard (branch: `feature/home`)

```bash
git checkout develop && git checkout -b feature/home
```

### `lib/features/home/data/quota_repository.dart`

Reads `usage_quotas` table from Supabase for the current user. Exposes:
- `getQuota(userId)` → returns `UsageQuota` model with: `scansUsed`, `conversionsUsed`, `ocrUsed`, `charsTranslated`, `periodStart`
- Falls back to Drift cache if offline

### `lib/features/home/presentation/home_screen.dart`

**Layout — `CustomScrollView` with `SliverAppBar`:**

**Expanded AppBar content** (`vsPrimary` background):
- Time-aware greeting: before noon → `'Good morning'` / `'Bonjour'`, noon–6pm → `'Good afternoon'` / `'Bon après-midi'`, evening → `'Good evening'` / `'Bonsoir'`
- Display: `'[Greeting], [FirstName]'` in `headlineMedium`, white
- `'What would you like to do today?'` / `'Que souhaitez-vous faire aujourd\'hui?'` in `bodySmall`, `vsAccent`

**Pinned AppBar:** `'VeriScript'` title + `IconButton(Icons.notifications_outlined)` trailing

**Sliver content (below AppBar):**

---

**1 — Offline banner** (only visible when `isOfflineProvider` is true):
`VsOfflineBanner` widget — see Task 12.

---

**2 — Quota bar widget** (`lib/features/home/presentation/quota_bar_widget.dart`):

White `VsCard`, padding 16:
- Title row: `'Monthly Usage'` / `'Utilisation mensuelle'` + small `'Free plan'` / `'Plan gratuit'` badge in `vsGray`
- 4 `LinearPercentIndicator` bars (from `percent_indicator` package):

| Bar | Label | Limit |
|---|---|---|
| Scans | Plagiarism Scans | 3 / month |
| Conversions | File Conversions | 5 / month |
| OCR | OCR Scans | 10 / month |
| Translation | Translation | 5,000 chars |

- Bar colour: `vsAccent` when < 80%, `vsWarning` when 80–99%, `vsError` at 100%
- Show shimmer (`shimmer` package) while data is loading
- If any bar hits 100%: show `TextButton` `'Upgrade — unlimited access'` / `'Mettre à niveau — accès illimité'` below the quota card → navigates to `/settings` (payment is Phase 3 — settings is a placeholder for now)

---

**3 — Tool cards grid:**

2-column `GridView.count` (crossAxisCount: 2, childAspectRatio: 0.95, spacing: 12):

| Icon | Name (EN) | Name (FR) | Description (EN) | Description (FR) | Route |
|---|---|---|---|---|---|
| `Icons.document_scanner_rounded` | Plagiarism Check | Vérif. de plagiat | Scan for copied content | Analysez le contenu copié | `/scanner` |
| `Icons.swap_horiz_rounded` | File Converter | Convertisseur | PDF, DOCX, TXT | PDF, DOCX, TXT | `/converter` |
| `Icons.camera_alt_rounded` | OCR Scanner | Numériseur OCR | Scan physical docs | Numérisez des docs physiques | `/ocr` |
| `Icons.translate_rounded` | Translator | Traducteur | 100+ languages | 100+ langues | `/translator` |

Each card — white `VsCard` with `InkWell`:
- Circular `Container` (56×56, `vsBackground`) holding the icon in `vsAccent`
- `SizedBox(height: 12)`
- Tool name in `titleLarge`, `vsDark`
- Tool description in `bodySmall`, `vsGray`

---

**4 — Recent documents section:**

Header row: `'Recent Documents'` / `'Documents récents'` (titleLarge) + `TextButton` `'See all'` / `'Voir tout'` → `/history`

Horizontal `ListView.builder` (height: 100) from Drift `documentsDao.getRecentDocuments()`:

Each document card (white, radius 12, width 160):
- File type icon (`Icons.picture_as_pdf` / `Icons.description` / `Icons.article`) in `vsAccent`
- Filename truncated to 1 line
- Date in `bodySmall` `vsGray`
- File type badge chip

If list is empty → `VsEmptyState` widget with `empty.json`, title `'No documents yet'` / `'Aucun document'`, subtitle `'Upload your first document!'` / `'Importez votre premier document!'`

---

**5 — WhatsApp share banner** (bottom of scroll):

`VsCard` with `vsAccent` left border:
- `Text('Share VeriScript with your class')` / `'Partagez VeriScript avec votre classe'` — `bodyLarge`
- `SizedBox(height: 8)`
- `ElevatedButton.icon` with `Icons.share` icon, label `'Share on WhatsApp'` / `'Partager sur WhatsApp'`:
  - Style: Green background `Color(0xFF25D366)`, white text
  - `share_plus` `Share.share()` with text:
    - EN: `'Check out VeriScript — plagiarism detection + file conversion for students in Cameroon! Download: [Play Store link]'`
    - FR: `'Découvrez VeriScript — détection de plagiat + conversion de fichiers pour les étudiants au Cameroun! Télécharger: [lien Play Store]'`

Commit: `feat: home dashboard — quota bar, tool cards, recent docs, WhatsApp share`

Merge: `git checkout develop && git merge feature/home --no-ff`

---

## 13. Task 10 — File Converter UI (branch: `feature/converter`)

```bash
git checkout develop && git checkout -b feature/converter
```

### `lib/features/converter/domain/conversion_job.dart`

Freezed class:
```dart
@freezed
class ConversionJob with _$ConversionJob {
  const factory ConversionJob({
    required String id,
    required String documentId,
    required String userId,
    required String fromFormat,
    required String toFormat,
    required String status, // pending | processing | done | failed
    String? outputPath,
    required DateTime createdAt,
  }) = _ConversionJob;
}
```

### `lib/features/converter/data/conversion_repository.dart`

Methods:
- `uploadFile(File file)` → upload to Supabase Storage bucket `'documents'` at path `'userId/filename'` → return storage path
- `insertJob(fromFormat, toFormat, storagePath)` → insert to `conversion_jobs` table → return job id
- `callConvertEdgeFunction(jobId, storagePath, fromFormat, toFormat)` → POST to Supabase Edge Function `'convert-file'`
- `watchJobStatus(String jobId)` → `Stream<String>` via Supabase Realtime on `conversion_jobs` table, filter `id=eq.jobId`, map to status string
- `getSignedDownloadUrl(String outputPath)` → Supabase Storage signed URL (60 min expiry)

### `lib/features/converter/presentation/converter_notifier.dart`

`AsyncNotifier` managing a `ConverterState`:
```dart
class ConverterState {
  final File? selectedFile;
  final String? fromFormat;
  final String toFormat;
  final String? currentJobId;
  final String jobStatus; // idle | uploading | processing | done | failed
  final String? downloadUrl;
  final String? errorMessage;
}
```

Methods:
- `pickFile()` — uses `file_picker`, detects format from extension
- `setTargetFormat(String format)`
- `startConversion()` — orchestrates upload → insert job → call Edge Function → subscribe to Realtime
- `reset()` — clears state for "Convert Another"

### Edge Function stub — `supabase/functions/convert-file/index.ts`

Create the Deno Edge Function directory and file. This is a **stub** — it simulates conversion for UI testing:

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const { jobId, storagePath, fromFormat, toFormat } = await req.json()

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  // Update job to processing
  await supabase.from('conversion_jobs').update({ status: 'processing' }).eq('id', jobId)

  // Simulate conversion delay (replace with real CloudConvert call later)
  await new Promise(resolve => setTimeout(resolve, 3000))

  // Update job to done with placeholder output path
  await supabase.from('conversion_jobs').update({
    status: 'done',
    output_path: `placeholder/converted_${jobId}.${toFormat}`
  }).eq('id', jobId)

  return new Response(JSON.stringify({ success: true }), {
    headers: { 'Content-Type': 'application/json' }
  })
})
```

### `lib/features/converter/presentation/converter_screen.dart`

The screen has **3 visual states** driven by `converterNotifier`:

**State 1 — File selection (jobStatus == 'idle' && selectedFile == null):**

- `AppBar` title: `'File Converter'` / `'Convertisseur de fichiers'`
- Center: dashed-border `Container` (use `BoxDecoration` with `Border.all` and `BorderStyle.dashed` workaround — use a `CustomPainter` for a real dashed border):
  - `Icon(Icons.upload_file_rounded, size: 64, color: vsAccent)`
  - `Text('Tap to select a file')` / `'Appuyez pour sélectionner un fichier'` — `titleLarge`
  - `Text('PDF, DOCX, TXT · Max 10MB')` / `'PDF, DOCX, TXT · Max 10 Mo'` — `bodySmall vsGray`
  - Full `InkWell` on tap → `converterNotifier.pickFile()`
- After file picked, if size > 5MB: show `SnackBar` warning about data usage

**State 2 — Format selection (selectedFile != null && jobStatus == 'idle'):**

- File info `VsCard`:
  - File icon (by format), filename, size formatted (KB/MB), format badge chip
- `Text('Convert to:')` / `'Convertir en:'` — `bodyLarge bold`
- `Wrap` of format chips — exclude current format:
  - `FilterChip` for each: PDF, DOCX, TXT
  - Selected: `vsAccent` background, white label
  - Unselected: `vsBackground` background, `vsDark` label
- Remaining conversions note: `'5 of 5 free conversions remaining'` / `'5 sur 5 conversions gratuites restantes'` — `bodySmall vsGray`
- `ElevatedButton('Convert Now')` / `'Convertir maintenant'` — full width, disabled if no target format selected
- `TextButton('Choose different file')` / `'Choisir un autre fichier'` → resets file selection

**State 3 — Progress + Result (jobStatus == 'uploading' | 'processing' | 'done' | 'failed'):**

Processing view:
- `CircularProgressIndicator(color: vsAccent)` size 64
- Animated status text (switch on jobStatus):
  - `'uploading'` → `'Uploading your file...'` / `'Téléchargement de votre fichier...'`
  - `'processing'` → `'Converting your document...'` / `'Conversion de votre document...'`
- Subscribe to `converterNotifier.stream` to rebuild on status change

Done view:
- `Icon(Icons.check_circle_rounded, color: vsSuccess, size: 80)`
- `Text('Conversion complete!')` / `'Conversion terminée!'` — `headlineMedium`
- `ElevatedButton('Download File')` / `'Télécharger le fichier'` → opens signed URL via `url_launcher` (add `url_launcher: ^6.3.0` to pubspec)
- `OutlinedButton('Convert Another')` / `'Convertir un autre'` → `converterNotifier.reset()`

Failed view:
- `VsErrorView(message: errorMessage, onRetry: converterNotifier.startConversion)`

Commit: `feat: converter screen with 3-state UI, Edge Function stub, and Realtime job tracking`

Merge: `git checkout develop && git merge feature/converter --no-ff`

---

## 14. Task 11 — Drift Local DB (branch: `feature/local-db`)

```bash
git checkout develop && git checkout -b feature/local-db
```

### Tables

**`lib/core/local_db/tables/documents_table.dart`**
```
id          TextColumn  primaryKey
userId      TextColumn
name        TextColumn
type        TextColumn  // pdf | docx | txt
storagePath TextColumn
sizeBytes   IntColumn   nullable
createdAt   DateTimeColumn  withDefault: currentDateAndTime
```

**`lib/core/local_db/tables/scan_reports_table.dart`**
```
id            TextColumn  primaryKey
documentId    TextColumn
userId        TextColumn
similarityPct RealColumn  nullable
status        TextColumn  // pending|processing|done|failed
sourcesJson   TextColumn  nullable
reportPdfUrl  TextColumn  nullable
createdAt     DateTimeColumn
```

**`lib/core/local_db/tables/translations_table.dart`**
```
id          TextColumn  primaryKey
userId      TextColumn
documentId  TextColumn  nullable
sourceLang  TextColumn
targetLang  TextColumn
inputText   TextColumn
outputText  TextColumn
createdAt   DateTimeColumn
```

**`lib/core/local_db/tables/conversion_jobs_table.dart`**
```
id          TextColumn  primaryKey
documentId  TextColumn
userId      TextColumn
fromFormat  TextColumn
toFormat    TextColumn
status      TextColumn
outputPath  TextColumn  nullable
createdAt   DateTimeColumn
```

### `lib/core/local_db/app_database.dart`

```dart
@DriftDatabase(tables: [DocumentsTable, ScanReportsTable, TranslationsTable, ConversionJobsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'veriscipt.db'));
    return NativeDatabase.createInBackground(file);
  });
}
```

### DAOs

**DocumentsDao:**
- `insertDocument(DocumentsTableCompanion)` → `Future<void>`
- `getRecentDocuments(String userId, {int limit = 10})` → `Future<List<DocumentsTableData>>`
- `watchAllDocuments(String userId)` → `Stream<List<DocumentsTableData>>`
- `deleteDocument(String id)` → `Future<int>`

**ScanReportsDao:**
- `insertReport(ScanReportsTableCompanion)` → `Future<void>`
- `watchRecentReports(String userId, {int limit = 30})` → `Stream<List<ScanReportsTableData>>`
- `updateStatus(String id, String status, {double? similarityPct})` → `Future<void>`

**TranslationsDao:**
- `cacheTranslation(TranslationsTableCompanion)` → `Future<void>`
- `findCached(String userId, String inputText, String source, String target)` → `Future<TranslationsTableData?>`
- `watchRecent(String userId, {int limit = 20})` → `Stream<List<TranslationsTableData>>`

### Riverpod providers

```dart
final appDatabaseProvider    = Provider((ref) => AppDatabase());
final documentsDaoProvider   = Provider((ref) => ref.watch(appDatabaseProvider).documentsDao);
final scanReportsDaoProvider = Provider((ref) => ref.watch(appDatabaseProvider).scanReportsDao);
final translationsDaoProvider= Provider((ref) => ref.watch(appDatabaseProvider).translationsDao);
```

### Run code generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Must complete with zero errors.

Commit: `feat: Drift local DB — all 4 tables, 3 DAOs, and Riverpod providers`

Merge: `git checkout develop && git merge feature/local-db --no-ff`

---

## 15. Task 12 — Shared Widgets + i18n (branch: `feature/i18n`)

```bash
git checkout develop && git checkout -b feature/i18n
```

### `lib/l10n/app_en.arb`

```json
{
  "@@locale": "en",
  "appName": "VeriScript",
  "splashTagline": "Document Integrity Suite",
  "onboardingTitle1": "Check for Plagiarism Instantly",
  "onboardingBody1": "Scan any document against billions of sources. Get detailed reports in seconds.",
  "onboardingTitle2": "Convert, Translate & Scan",
  "onboardingBody2": "PDF to Word, 100+ language translation, and OCR scanning — all in one app.",
  "onboardingTitle3": "Built for Students in Cameroon",
  "onboardingBody3": "Join thousands of students at universities across Cameroon. Start free today.",
  "onboardingCta": "Get Started Free",
  "onboardingSignIn": "Already have an account? Sign in",
  "loginTitle": "Welcome Back",
  "loginEmail": "Email address",
  "loginPassword": "Password",
  "loginButton": "Sign In",
  "loginForgot": "Forgot password?",
  "loginNoAccount": "Create account",
  "registerTitle": "Create Account",
  "registerName": "Full Name",
  "registerEmail": "Email address",
  "registerPassword": "Password",
  "registerConfirm": "Confirm password",
  "registerButton": "Create Account",
  "registerTerms": "I agree to the Terms of Service",
  "registerSuccess": "Check your email to confirm your account",
  "forgotTitle": "Reset Password",
  "forgotEmail": "Email address",
  "forgotButton": "Send Reset Link",
  "forgotSuccess": "Check your email for a reset link",
  "homeGreetingMorning": "Good morning",
  "homeGreetingAfternoon": "Good afternoon",
  "homeGreetingEvening": "Good evening",
  "homeSubtitle": "What would you like to do today?",
  "homeToolScanner": "Plagiarism Check",
  "homeToolScannerDesc": "Scan for copied content",
  "homeToolConverter": "File Converter",
  "homeToolConverterDesc": "PDF, DOCX, TXT",
  "homeToolOcr": "OCR Scanner",
  "homeToolOcrDesc": "Scan physical docs",
  "homeToolTranslator": "Translator",
  "homeToolTranslatorDesc": "100+ languages",
  "homeRecentDocs": "Recent Documents",
  "homeSeeAll": "See all",
  "homeEmptyDocs": "No documents yet",
  "homeEmptyDocsSubtitle": "Upload your first document!",
  "homeUploadFirst": "Upload Document",
  "homeShareLabel": "Share VeriScript with your class",
  "homeShareButton": "Share on WhatsApp",
  "homeShareText": "Check out VeriScript — plagiarism detection + file conversion for students in Cameroon! Download: https://play.google.com/store/apps/details?id=com.veriscipt.mobile",
  "homeMonthlyUsage": "Monthly Usage",
  "homeFreePlan": "Free plan",
  "homeUpgradeNudge": "Upgrade — unlimited access",
  "converterTitle": "File Converter",
  "converterSelectFile": "Tap to select a file",
  "converterFileTypes": "PDF, DOCX, TXT · Max 10MB",
  "converterLargeFile": "Large file — this may use significant mobile data",
  "converterConvertTo": "Convert to:",
  "converterChooseDifferent": "Choose different file",
  "converterButton": "Convert Now",
  "converterFreeRemaining": "{used} of {max} free conversions remaining this month",
  "@converterFreeRemaining": {
    "placeholders": {
      "used": { "type": "int" },
      "max": { "type": "int" }
    }
  },
  "converterUploading": "Uploading your file...",
  "converterConverting": "Converting your document...",
  "converterDone": "Conversion complete!",
  "converterDownload": "Download File",
  "converterAnother": "Convert Another",
  "errorNetworkTitle": "No connection",
  "errorNetworkBody": "Check your internet and try again.",
  "errorGenericTitle": "Something went wrong",
  "errorRetry": "Try again",
  "offlineBanner": "You are offline — showing cached data",
  "settingsTitle": "Settings",
  "settingsLanguage": "Language / Langue",
  "stubComingSoon": "Coming in Phase 2",
  "authErrorInvalidCredentials": "Invalid email or password",
  "authErrorEmailInUse": "An account already exists with this email",
  "authErrorWeakPassword": "Password must be at least 8 characters",
  "authErrorNetwork": "No connection. Check your internet.",
  "authErrorUnknown": "Something went wrong. Please try again."
}
```

### `lib/l10n/app_fr.arb`

Create the same keys with French translations matching all the French copy in the task descriptions above.

### Shared widgets — implement fully

**`lib/core/widgets/vs_button.dart`**

Named constructors:
- `VsButton.primary({required String label, required VoidCallback? onPressed, bool isLoading = false, IconData? icon})`
  - `ElevatedButton`, full width, height 52, `vsCta` bg, `vsDark` text, radius 12
  - When `isLoading`: replace label with `SizedBox(18,18, CircularProgressIndicator(strokeWidth: 2, color: vsDark))`
- `VsButton.secondary({required String label, required VoidCallback? onPressed, bool isLoading = false})`
  - `OutlinedButton`, full width, `vsAccent` border, `vsAccent` text
- `VsButton.text({required String label, required VoidCallback? onPressed})`
  - `TextButton`, `vsAccent` text, no background

**`lib/core/widgets/vs_card.dart`**

```dart
class VsCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  // White bg, elevation 2, radius 16
  // If onTap: wrap in InkWell with borderRadius 16, splash color vsAccent.withOpacity(0.1)
}
```

**`lib/core/widgets/vs_offline_banner.dart`**

`AnimatedContainer` that slides in from top when `isOfflineProvider` is true:
- `vsWarning` background, white text, `Icons.wifi_off` icon
- `'You are offline — showing cached data'` / ARB key `offlineBanner`
- Height: 0 when online, 40 when offline — use `AnimatedContainer(duration: 300ms)`

**`lib/core/widgets/vs_loading.dart`**

Full-screen overlay:
```dart
// Stack > Positioned.fill > IgnorePointer > Container(color: black26) > Center > Lottie.asset(loading.json, 120x120)
```

**`lib/core/widgets/vs_empty_state.dart`**

```dart
class VsEmptyState extends StatelessWidget {
  final String lottieAsset;
  final String title;
  final String? subtitle;
  final Widget? action;
  // Centered column: Lottie 150x150, title titleLarge, subtitle bodySmall vsGray, action widget
}
```

**`lib/core/widgets/vs_error_view.dart`**

```dart
class VsErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  // Icon error_outline vsError size 64, message bodyLarge, VsButton.primary('Try again')
}
```

**`lib/core/widgets/vs_app_bar.dart`**

Custom `PreferredSizeWidget` AppBar:
- `vsPrimary` background
- `'VeriScript'` title in `Inter SemiBold 18sp` white
- Optional trailing actions

**`lib/core/network/dio_client.dart`**

Dio singleton with:
- Base options: 30s connect timeout, 60s receive timeout
- `LogInterceptor` (debug only)
- `InterceptorsWrapper` that adds Supabase auth header: `Authorization: Bearer [currentSession?.accessToken]`

**`lib/core/network/edge_function_caller.dart`**

Helper that wraps `supabase.functions.invoke(functionName, body: body)` and maps errors to typed exceptions.

After writing all widgets, run:
```bash
flutter gen-l10n
```

Commit: `feat: EN/FR ARB localisation, all shared VS widgets, Dio client`

Merge: `git checkout develop && git merge feature/i18n --no-ff`

---

## 16. Task 13 — Stub Screens (branch: `feature/stubs`)

```bash
git checkout develop && git checkout -b feature/stubs
```

Fully implement these 4 screens as **polished stubs** — they must look good and feel intentional, not like placeholders. Each gets a proper AppBar, the VeriScript theme, and a visually appealing "coming soon" state.

### `lib/features/scanner/presentation/scanner_screen.dart`

- `VsAppBar` title: `'Plagiarism Check'` / `'Vérification de plagiat'`
- Center: `VsEmptyState` with `empty.json` Lottie
- Title: `'Plagiarism Scanner'` / `'Vérificateur de plagiat'`
- Subtitle: `'Coming in Phase 2 — upload a document to check for plagiarism'` / `'Disponible en Phase 2 — importez un document pour vérifier le plagiat'`
- Action button: `VsButton.secondary('Learn more')` / `'En savoir plus'` — shows a `BottomSheet` explaining what the scanner will do

### `lib/features/ocr/presentation/ocr_screen.dart`

- `VsAppBar` title: `'OCR Scanner'` / `'Numériseur OCR'`
- Same `VsEmptyState` pattern
- Subtitle: `'Coming in Phase 2 — scan physical documents with your camera'` / `'Disponible en Phase 2 — numérisez des documents physiques avec votre caméra'`

### `lib/features/translator/presentation/translator_screen.dart`

- `VsAppBar` title: `'Translator'` / `'Traducteur'`
- Same pattern
- Subtitle: `'Coming in Phase 2 — translate documents into 100+ languages'` / `'Disponible en Phase 2 — traduisez des documents en 100+ langues'`

### `lib/features/history/presentation/history_screen.dart`

- `VsAppBar` title: `'History'` / `'Historique'`
- Read recent documents from `documentsDaoProvider` (Drift DB)
- If empty: `VsEmptyState`
- If documents exist: `ListView.builder` with simple document list tiles:
  - File type icon, filename, date, type badge
  - Delete swipe action (`Dismissible`)
- This screen shows real local data — it is not a stub in the data sense, only the Supabase sync is Phase 2

Commit: `feat: polished stub screens for scanner, OCR, translator; real history from Drift`

Merge: `git checkout develop && git merge feature/stubs --no-ff`

---

## 17. Task 14 — Final Merge + Verification

```bash
git checkout develop
```

Run each of the following. Every command must complete without errors before moving to the next:

```bash
# 1. Get all packages
flutter pub get

# 2. Generate Drift + Riverpod + Freezed code
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Generate l10n files
flutter gen-l10n

# 4. Analyse the codebase — fix all errors (warnings are acceptable)
flutter analyze

# 5. Run the app with placeholder credentials
flutter run \
  --dart-define=SUPABASE_URL=https://placeholder.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=placeholder \
  --dart-define=SENTRY_DSN=placeholder
```

**Expected app behaviour:**
- Launches to splash screen with Lottie animation
- After 2.8 seconds → redirects to onboarding (first launch)
- Onboarding shows 3 slides with correct EN copy (or FR if device locale is French)
- Tapping `'Get Started Free'` → navigates to Register screen
- Register and Login screens render correctly with all form fields
- Bottom navigation shell renders for authenticated users
- Home dashboard shows tool cards and empty recent docs state
- Converter screen shows file picker state correctly
- All stub screens show the polished empty state

### Create `PHASE1_SUMMARY.md`

```markdown
# VeriScript Phase 1 — Build Summary

## Branches merged to develop
- feature/theme
- feature/supabase-init
- feature/navigation
- feature/splash
- feature/onboarding
- feature/auth
- feature/home
- feature/converter
- feature/local-db
- feature/i18n
- feature/stubs

## Placeholder values to replace
- SUPABASE_URL in .env.local
- SUPABASE_ANON_KEY in .env.local
- SENTRY_DSN in .env.local
- Lottie JSON files in assets/animations/ (replace placeholders with real animations from lottiefiles.com)
- WhatsApp number in home_screen.dart share banner
- Play Store URL in app_en.arb and app_fr.arb homeShareText

## Phase 2 features (not in this build)
- Plagiarism scanner (Copyleaks API)
- OCR camera (ML Kit full implementation)
- Translator (Google Cloud Translate)
- History Supabase sync
- Google Drive integration
- Push notifications
- Payment / subscription screen

## How to run
1. Copy .env.local.example to .env.local and fill in real values
2. flutter pub get
3. flutter pub run build_runner build --delete-conflicting-outputs
4. flutter gen-l10n
5. flutter run --dart-define-from-file=.env.local
```

### Final git commands

```bash
git add .
git commit -m "chore: Phase 1 complete — all features integrated"

# Merge develop → main
git checkout main
git merge develop --no-ff
git tag -a v0.1.0-phase1 -m "Phase 1: Foundation, Auth, Home, Converter, DB, i18n"
git push origin main --tags
git push origin develop
```

---

## 18. Gemini (Android Studio) Instructions

Use Gemini in Android Studio for the following tasks **after each branch merges**. Do not ask Gemini to restructure the project — Codex owns architecture.

| After Codex merges | Ask Gemini |
|---|---|
| `feature/theme` | Review `app_colors.dart` and suggest contrast improvements for outdoor mobile viewing |
| `feature/auth` | Write unit tests for `AuthNotifier`: sign-in success, wrong password, email in use, network error |
| `feature/home` | Review `quota_bar_widget.dart` and suggest a caching improvement for low-data users |
| `feature/converter` | Review `ConversionRepository` and improve error handling for intermittent network |
| `feature/local-db` | Write a test verifying all 4 Drift tables are created on first install |
| `feature/i18n` | Check all ARB keys are used — find any hardcoded English strings in the codebase |

**For build errors after any merge, paste this to Gemini:**
> "A new branch was just merged. Here is the build error: [paste error]. The project uses Flutter 3.x, Riverpod 2, go_router, Supabase Flutter, and Drift with feature-first Clean Architecture. Fix only the failing file — do not refactor anything else."

**For AndroidManifest.xml, ask Gemini:**
> "Review `android/app/src/main/AndroidManifest.xml` for this Flutter app. It uses: camera, file_picker, flutter_local_notifications, connectivity_plus, google_sign_in. Add all required permissions and the FileProvider config for file_picker. Keep changes minimal — only add what is strictly required for Android API 21+."

---

## 19. Phase 2 Preview

When `v0.1.0-phase1` is tagged — the following features are built next:

| Priority | Feature | Why it matters for Cameroon |
|---|---|---|
| 1 | **Plagiarism Scanner** — Copyleaks API full integration | Core reason students download the app |
| 2 | **Originality Report** — `fl_chart` similarity ring + PDF export | Visual proof for lecturers |
| 3 | **OCR Scanner** — ML Kit camera implementation | Physical document scanning dominates in Cameroon |
| 4 | **Translator** — Google Cloud Translate v3 | French ↔ English is a daily need in bilingual Cameroon |
| 5 | **History sync** — Supabase + Drift full sync | Stickiness — users return to past work |
| 6 | **Google Drive** — import/export | Students store coursework on Drive |
| 7 | **Push notifications** — scan complete alerts | Users leave the app while long scans run |
| 8 | **Referral system** — share code for bonus scans | WhatsApp groups are the growth engine |
| 9 | **Payment screen** — MTN MoMo + Orange Money | Removes the biggest payment barrier in Cameroon |
| 10 | **University onboarding** — UYI, BUEA, IRIC branding | Personalised = trusted |

---

*VeriScript Phase 1 · Flutter + Supabase · Built for Cameroon*
