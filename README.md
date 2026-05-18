# VeriScript Mobile

## 📱 Overview
VeriScript is a Flutter + Supabase powered **document integrity and productivity app** designed for students and professionals in Cameroon and Francophone Africa.

It provides:
- Plagiarism detection
- File conversion (PDF, DOCX, TXT)
- OCR document scanning
- Translation (100+ languages)
- Offline document access

---

## 🧱 Tech Stack
- Flutter 3.x / Dart 3.x
- Supabase (Backend + Auth + Edge Functions)
- Riverpod 2 (State Management)
- go_router (Navigation)
- Drift (Local Database)
- RevenueCat (Subscriptions)

---

## 🌍 Target Market Considerations (Cameroon)

- Mobile Money dominant (MTN MoMo, Orange Money)
- Expensive mobile data → optimize all network usage
- Bilingual (English + French)
- Offline-first required
- Android-first platform
- Student-focused pricing

---

## 🌿 Git Workflow

### Branch Strategy
- `main` → production
- `develop` → integration
- `feature/*` → individual features

### Rules
- Never commit directly to `main` or `develop`
- Use Conventional Commits:
  - `feat:` new feature
  - `chore:` maintenance
  - `fix:` bug fix

---

## 🚀 Phase 1 Tasks

| # | Task | Branch | Output |
|--|------|--------|--------|
| 1 | Git setup | main/develop | Clean repo |
| 2 | Dependencies | develop | pubspec working |
| 3 | Folder structure | develop | Clean architecture |
| 4 | Theme | feature/theme | UI system |
| 5 | Supabase init | feature/supabase-init | Backend ready |
| 6 | Navigation | feature/navigation | Routing system |
| 7 | Splash | feature/splash | Entry screen |
| 8 | Onboarding | feature/onboarding | User intro |
| 9 | Auth | feature/auth | Login/Register |
|10 | Home | feature/home | Dashboard |
|11 | Converter | feature/converter | File conversion |
|12 | Local DB | feature/local-db | Offline storage |
|13 | Monetization | feature/monetization | Paywall |
|14 | i18n | feature/i18n | EN/FR support |

---

## 📦 Dependencies (pubspec.yaml)

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

  supabase_flutter: ^2.5.0
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^13.2.0
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0
  dio: ^5.4.3
  flutter_secure_storage: ^9.2.2
  file_picker: ^8.0.6
  camera: ^0.10.5+9
  google_mlkit_text_recognition: ^0.13.0
  google_sign_in: ^6.2.1
  purchases_flutter: ^7.0.0
  drift: ^2.19.1
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.4
  path: ^1.9.0
  fl_chart: ^0.68.0
  lottie: ^3.1.2
  cached_network_image: ^3.3.1
  google_fonts: ^6.2.1
  share_plus: ^9.0.0
  flutter_local_notifications: ^17.2.3
  connectivity_plus: ^6.0.3
  shimmer: ^3.0.0
  percent_indicator: ^4.2.3
  sentry_flutter: ^7.18.0
  intl: ^0.19.0

----


## 📁 Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
├── features/
├── l10n/
```

### Architecture Style
- Feature-first
- Clean Architecture
- Riverpod-based state management

---

## 🔐 Environment Variables

Create `.env.local`:

```
SUPABASE_URL=your_url
SUPABASE_ANON_KEY=your_key
REVENUECAT_ANDROID_KEY=your_key
SENTRY_DSN=your_dsn
```

Run app with:

```bash
flutter run --dart-define-from-file=.env.local
```

---

## 🎨 Theme System

### Colors
- Primary: Deep Navy (#1A3C5E)
- Accent: Teal Mint (#2BBFAA)
- CTA: Amber Gold (#F4A300)

### Design
- Material 3
- Google Fonts (Inter)
- Clean, student-friendly UI

---

## 🔑 Core Features

### 1. Authentication
- Email login/register
- Password reset
- Supabase Auth

### 2. Dashboard
- Usage quota tracking
- Tool cards
- Recent documents
- WhatsApp sharing

### 3. File Converter
- Upload → Convert → Download
- CloudConvert via Edge Function
- Realtime progress updates

### 4. Offline Support
- Drift database
- Cached documents
- Low-data optimization

### 5. Monetization
- Free tier vs Plus

#### Pricing (XAF)
- Monthly: 3,000 XAF
- Annual: 12,000 XAF

---

## 💰 Monetization Strategy

| Feature        | Free        | Plus        |
|----------------|------------|------------|
| Scans          | 3/month    | Unlimited  |
| Conversion     | 5/month    | Unlimited  |
| OCR            | 10/month   | Unlimited  |
| Translation    | 5K chars   | 500K chars |
| PDF Export     | ❌          | ✅          |
| Offline Docs   | 10         | 50         |

---

## 🌐 Internationalization

### Supported Languages
- English 🇬🇧
- French 🇫🇷

### ARB Files Location
```
lib/l10n/app_en.arb
lib/l10n/app_fr.arb
```

---

## ⚡ Build Instructions

```bash
flutter pub get
flutter analyze
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```
