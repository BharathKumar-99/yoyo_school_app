# Yoyo School App - Technical Documentation

## 1. Project Overview
**Yoyo School App** is a comprehensive educational Flutter application aimed at students. The app provides features such as interactive homework, language learning (phrases, listen and type), user profile management, and real-time push notifications. It relies heavily on Supabase for backend services (Authentication, Database, Real-time) and Firebase for push messaging.

## 2. Architecture & State Management
The project strictly follows a feature-first, layered architecture.

- **Presentation Layer**: Built using Flutter widgets. Uses declarative UI principles.
- **State Management**: Uses `Provider` package (specifically `ChangeNotifierProvider` and `MultiProvider`). Business logic and state handling are separated from UI screens into dedicated `Provider` and `ViewModel` classes (e.g., `ProfileProvider`, `HomeScreenProvider`, `AuthProvider`).
- **Data/Repository Layer**: Dedicated repository classes (e.g., `HomeRepository`, `ProfileRepository`) handle data fetching and encapsulate backend calls (via Supabase), returning parsed domain models.

## 3. Directory Structure
```text
lib/
├── app.dart                   # Main app widget and MultiProvider wrapper
├── bootstrap/                 # Initialization logic (AppInitializer, FCM, Handlers)
├── config/                    # Global app configuration
│   ├── constants/             # App-wide constants (colors, strings, keys)
│   ├── router/                # go_router configuration and route names
│   ├── theme/                 # AppTheme (Light/Dark themes)
│   └── utils/                 # General utility functions and helpers
├── core/                      # Core infrastructure
│   ├── audio/                 # Audio playing/recording services
│   ├── supabase/              # Supabase client initialization wrapper
│   └── widgets/               # Reusable, core UI components
├── features/                  # Feature modules
│   ├── auth/                  # Login, OTP verification
│   ├── common/                # Shared domain logic (GlobalProvider, etc.)
│   ├── home/                  # Dashboard and main landing screen
│   ├── homework/              # Homework viewing and submission
│   ├── listen_and_type/       # Interactive learning (Listening & Typing)
│   ├── master_phrase/         # Phrase mastery features
│   ├── onboarding_screen/     # First-time user experience
│   ├── phrases/               # Phrase browsing and categories
│   ├── profile/               # User profile and settings
│   └── splash/                # Splash screen logic
├── firebase_options.dart      # Auto-generated Firebase config
├── l10n/                      # Localization delegates (intl)
└── main.dart                  # Application entry point
```

## 4. Key Dependencies
- **State Management**: `provider` (^6.1.5+1)
- **Routing**: `go_router` (^16.2.4)
- **Backend (BaaS)**: `supabase_flutter` (^2.10.1)
- **Push Notifications**: `firebase_messaging` (^16.1.0), `flutter_local_notifications`
- **Local Storage**: `shared_preferences` (^2.5.3)
- **Media & Audio**: `just_audio`, `audio_waveforms`, `speech_to_text`, `ffmpeg_kit_flutter_new`
- **Machine Learning**: `google_mlkit_translation`
- **UI Utilities**: `lottie`, `cached_network_image`, `auto_size_text`, `flutter_otp_text_field`

## 5. Core Services
### Supabase Integration
The app communicates with a Supabase backend for Authentication and Database CRUD operations. The `SupabaseClientService` (in `lib/core/supabase/supabase_client.dart`) initializes the client. All database interactions are abstracted behind repository classes. Authentication flow uses OTP (WhatsApp/SMS) and is managed inside the Auth providers.

### Push Notifications
Implemented using Firebase Cloud Messaging (FCM). `NotificationServices` handles the initialization of FCM, requests for permissions, and background/foreground message handling.

### Global State & Initialization
`AppInitializer` (in `lib/bootstrap/app_initializer.dart`) ensures all critical services (Firebase, Supabase, Shared Preferences, GlobalProvider) are instantiated before the Flutter app is run.

## 6. Feature Modules
- **Authentication**: Handles user login via mobile number/email. OTP flow involves a timer for resending the code and communicates with the backend via `AuthProvider`.
- **Home**: The central dashboard displaying user progress, upcoming tasks, and quick actions. Managed by `HomeScreenProvider` and `HomeRepository`.
- **Homework & Learning (Phrases, Listen & Type)**: Provides interactive modules where students can view assignments, practice phrases, and complete typing tests based on audio cues. Extensive use of audio packages (`just_audio`).
- **Profile**: Allows the user to view and edit their profile details. Incorporates caching mechanisms to reduce network load.
- **Global / Common**: Contains `GlobalProvider` and error screens (e.g., `NetworkErrorScreen`). Handles app-wide connectivity status and gracefully shows fallbacks when offline.

## 7. Routing Setup
Routing is configured entirely via `go_router` in `lib/config/router/app_router.dart`. 
Key aspects:
- Centralized route definitions in `RouteNames` (e.g., `RouteNames.home`, `RouteNames.login`).
- Supports redirect logic (e.g., redirecting unauthenticated users to the Login/Splash screen).
- Route transition animations and nested navigation setups.

## 8. Error Handling & Edge Cases
- **Network Resilience**: The app listens to network connectivity changes. Streams in repositories (e.g., `ProfileRepository`) handle errors gracefully. If a severe network error occurs, users are routed to a dedicated `NetworkErrorScreen`. Upon clicking "Retry", `context.pop()` is utilized to return the user to their prior context rather than hard-resetting to Splash.
- **Global Error Handlers**: `ErrorHandlers.register()` catches global Flutter and Dart exceptions, preventing hard crashes and logging them for debugging.

## 9. Future Development Guide
1. **Adding a New Feature**: 
   - Create a new directory under `lib/features/`.
   - Implement the presentation logic (Screens/Widgets), state management (Provider), and data access (Repository).
   - Inject the provider in `app.dart` or locally within the route.
   - Register the route in `app_router.dart` and `route_names.dart`.
2. **State Management Protocol**: Never place API or heavy business logic directly inside stateful/stateless widgets. Always use the Provider/Repository pattern.
3. **API Changes**: All backend structural changes (Supabase tables/functions) must be mirrored in the respective Domain Models and Repositories.
