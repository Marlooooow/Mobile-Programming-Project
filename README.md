# AIDA — Flutter AI Chatbot

AIDA is a beginner-focused Android chatbot built with Flutter. It can generate
Markdown-formatted answers through Gemini or Groq and save conversation messages
to Supabase.

This repository accompanies **Case 01**, a learn-by-doing workshop for learners
with no previous programming or technology background.

## Documentation

- **[Start Case 01: Build AIDA step by step](Case-01.md)**
- [Configuration](#configuration)
- [Run and test](#run-and-test)
- [Build the APK](#build-the-apk)
- [Additional resources](#additional-resources)

## Case 01 learning outcomes

After completing the guided case, learners can:

- Install and validate Flutter and the Android development toolchain.
- Create and organize a Flutter project.
- Create a Supabase table with basic Row Level Security.
- Configure Gemini and Groq without placing keys in Dart source files.
- Build an interactive chat interface from Flutter widgets.
- Switch AI providers using one environment flag.
- Render AI responses as readable Markdown.
- Write and run basic logic and widget tests.
- Run AIDA on an emulator and physical Android phone.
- Produce an installable Android APK.

## Features

- Gemini and Groq provider selection through `AI_PROVIDER`.
- Gemini `gemini-3.6-flash` integration.
- Groq `llama-3.1-8b-instant` integration.
- Supabase message persistence.
- Markdown-formatted assistant responses.
- Friendly timeout, connection, configuration, and response errors.
- Dependency-injected services for reliable tests.
- Responsive Material 3 chat interface.

## Architecture

```text
lib/
├── main.dart                     # Configuration and application startup
├── models/
│   └── chat_message.dart         # Chat message data
├── screens/
│   └── chat_page.dart            # Chat interface and interaction flow
└── services/
    ├── ai_service.dart           # Shared provider contract and provider flag
    ├── chat_repository.dart      # Supabase message persistence
    ├── gemini_service.dart       # Gemini HTTP integration
    └── groq_service.dart         # Groq HTTP integration
```

The screen depends on shared interfaces rather than a specific database or AI
provider. This keeps provider switching simple and allows tests to use safe fake
services instead of real network requests.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/install/manual)
- [Android Studio](https://developer.android.com/studio/install)
- A [Supabase](https://supabase.com/) project
- A [Gemini API key](https://ai.google.dev/gemini-api/docs/api-key)
- A [Groq API key](https://console.groq.com/docs/quickstart) when using Groq

For complete installation and account instructions, follow
[Case-01.md](Case-01.md).

## Configuration

Copy `.env.example` to `.env`, then replace the placeholders with your local values:

```dotenv
AI_PROVIDER=gemini
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your_supabase_publishable_key
GEMINI_API_KEY=your_gemini_api_key
GROQ_API_KEY=your_groq_api_key
```

Set `AI_PROVIDER` to either:

- `gemini` — requires `GEMINI_API_KEY`
- `groq` — requires `GROQ_API_KEY`

The Supabase URL and publishable key are always required. `.env` and its local
variants are excluded by `.gitignore`; `.env.example` contains placeholders and
is safe to commit.

> **Security:** Values in a Flutter `.env` asset are bundled into the application
> and can be extracted from an APK. Use this configuration for learning and local
> development only. In production, keep Gemini and Groq credentials on a secure
> backend or Supabase Edge Function.

## Install dependencies

```powershell
flutter pub get
```

## Run and test

Start an emulator or connect an Android phone, then run:

```powershell
flutter run
```

Run static analysis and the automated test suite:

```powershell
flutter analyze
flutter test
```

Changing `.env`, adding an asset, or switching `AI_PROVIDER` requires stopping
and restarting the application rather than using hot reload.

## Build the APK

Build one release APK:

```powershell
flutter build apk
```

Build smaller architecture-specific release APKs:

```powershell
flutter build apk --split-per-abi
```

Flutter writes APK files under `build/app/outputs/flutter-apk/`. See the official
[Flutter Android release guide](https://docs.flutter.dev/deployment/android) for
signing, app bundles, and Play Store preparation.

## Model lifecycle notice

The project intentionally uses Groq's `llama-3.1-8b-instant` model for this case.
Groq has announced an August 16, 2026 shutdown for this model on free and
developer tiers, recommending `openai/gpt-oss-20b` as its replacement. Check the
[Groq deprecation schedule](https://console.groq.com/docs/deprecations) before
running the Groq exercise after that date.

## Additional resources

### Flutter and Android

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Flutter widget catalog](https://docs.flutter.dev/ui/widgets)
- [Testing Flutter apps](https://docs.flutter.dev/testing/overview)
- [Create Android virtual devices](https://developer.android.com/studio/run/managing-avds)
- [Run on a physical Android device](https://developer.android.com/studio/run/device)

### Supabase

- [Supabase Flutter quickstart](https://supabase.com/docs/guides/getting-started/quickstarts/flutter)
- [Supabase Flutter client](https://supabase.com/docs/reference/dart/installing)
- [Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security)

### AI providers

- [Gemini API documentation](https://ai.google.dev/gemini-api/docs)
- [Gemini API troubleshooting](https://ai.google.dev/gemini-api/docs/troubleshooting)
- [Groq quickstart](https://console.groq.com/docs/quickstart)
- [Groq API reference](https://console.groq.com/docs/api-reference)

## Project status

Case 01 is a teaching project intended for guided demonstrations and local
experimentation. Before public production use, add authentication, per-user RLS
policies, server-side AI credentials, abuse protection, release signing, and a
privacy policy.
