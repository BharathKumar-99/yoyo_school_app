# Onboarding for Developers

Welcome to the YoYo School App codebase! This guide will help you get started quickly and avoid common pitfalls.

---

## How to Run the Project
1. **Clone the repository**
   ```sh
   git clone <repo-url>
   cd yoyo_school_app
   ```
2. **Install dependencies**
   ```sh
   flutter pub get
   ```
3. **Configure Firebase**
   - Place `google-services.json` in `android/app/`
   - Place `GoogleService-Info.plist` in `ios/Runner/`
4. **Configure Supabase**
   - Set your Supabase keys in `lib/config/constants/constants.dart`
5. **Run the app**
   ```sh
   flutter run
   ```

---

## Important Entry Points
- `lib/main.dart` – App entry, initialization
- `lib/app.dart` – Root widget, providers, MaterialApp
- `lib/bootstrap/app_initializer.dart` – Startup logic
- `lib/config/router/app_router.dart` – Routing
- `lib/features/` – Feature modules (auth, home, profile, etc.)

---

## Where to Start Reading Code
1. `main.dart` → `AppInitializer` → `app.dart`
2. Explore `features/` for business logic and UI
3. Review `config/` for routing, theming, and utilities

---

## Key Concepts
- **Provider:** State management and dependency injection
- **Repository:** Data access abstraction (Supabase, APIs)
- **Model:** Data mapping from backend
- **Supabase:** Real-time backend, auth, and database
- **Firebase:** Push notifications
- **GoRouter:** Declarative navigation

---

## Common Pitfalls
- **Async initialization:** `GlobalProvider` is async; ensure it's ready before use
- **Real-time streams:** Always dispose streams in providers
- **Supabase keys:** Must be set correctly for backend access
- **Platform setup:** Firebase config files are required for push notifications
- **State leaks:** Always call `dispose()` in providers to avoid memory leaks

---

For architecture, data flow, and API details, see the other markdown docs in this repo.
