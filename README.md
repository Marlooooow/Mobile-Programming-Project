# aida

A new Flutter project.

## Configuration

Copy `.env.example` to `.env`, then provide your local configuration:

```dotenv
AI_PROVIDER=gemini
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your_supabase_publishable_key
GEMINI_API_KEY=your_gemini_api_key
GROQ_API_KEY=your_groq_api_key
```

Set `AI_PROVIDER` to `gemini` or `groq` to choose the active AI service. Only
the API key for the selected provider is required. The Groq integration uses
the `llama-3.1-8b-instant` model.

The app loads this file automatically at startup. `.env` and environment-specific
variants are excluded from Git; `.env.example` is safe to commit because it contains
only placeholders.

Do not treat values in a Flutter `.env` asset as production secrets. They are bundled
into the application and can be extracted from the APK. For production, keep private
AI credentials on a backend and have the app call that backend instead.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
