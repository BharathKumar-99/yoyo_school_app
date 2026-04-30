# YoYo School App

A modular, production-grade Flutter application for language learning in schools.

## Features
- User authentication and onboarding
- Home dashboard with real-time progress
- Profile management
- Homework and phrase practice
- Real-time updates via Supabase
- Push notifications (Firebase)
- Multi-language support
- Teacher and student roles

## Tech Stack
- **Flutter** (UI, state management)
- **Provider** (state management)
- **Supabase** (database, real-time, auth)
- **Firebase** (push notifications)
- **GoRouter** (navigation)
- **Shared Preferences** (local storage)

## Setup Instructions
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
	- Place your `google-services.json` in `android/app/`
	- Place your `GoogleService-Info.plist` in `ios/Runner/`
4. **Configure Supabase**
	- Set your Supabase keys in `lib/config/constants/constants.dart`
5. **Run the app**
	```sh
	flutter run
	```

## Folder Structure
- `lib/`
  - `app.dart` – Root widget, providers, MaterialApp
  - `main.dart` – Entry point, initialization
  - `bootstrap/` – App startup, notifications, error handling
  - `config/` – Routing, theming, constants, utilities
  - `core/` – Core services (Supabase, audio, widgets)
  - `features/` – Feature modules (auth, home, profile, etc.)
  - `l10n/` – Localization files
- `assets/` – Images, fonts, animations
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` – Platform code

---

For detailed architecture, data flow, and API docs, see:
- [ARCHITECTURE.md](ARCHITECTURE.md)
- [DATA_FLOW.md](DATA_FLOW.md)
- [API_DOCS.md](API_DOCS.md)
- [PROVIDER_LIFECYCLE.md](PROVIDER_LIFECYCLE.md)
- [FEATURE_FLOWS.md](FEATURE_FLOWS.md)
- [ONBOARDING.md](ONBOARDING.md)
