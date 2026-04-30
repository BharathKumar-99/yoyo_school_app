# Architecture

## High-Level Overview

The YoYo School App is architected using a modular, layered approach to maximize maintainability, scalability, and testability. The codebase is organized by feature and responsibility, with clear separation between UI, state management, data access, and core services.

---

## Layered Design

- **Presentation Layer (UI)**
  - Widgets, screens, and view models for user interaction
  - Consumes state from Providers
- **State Management Layer**
  - Providers (using `provider` package)
  - Handles business logic, state, and notifies UI
- **Data Layer**
  - Repositories abstracting Supabase, Firebase, and local storage
  - Models for data mapping
- **Core Services**
  - Supabase client, notification services, shared preferences, audio
- **Configuration**
  - Routing, theming, constants, utilities

---

## Folder/Module Breakdown

- `lib/app.dart` – Root widget, sets up providers and MaterialApp
- `lib/main.dart` – Entry point, runs initialization and app
- `lib/bootstrap/` – App startup, notification, error handling
- `lib/config/` – Routing (`app_router.dart`), theming, constants, utilities
- `lib/core/` – Supabase client, audio, widgets
- `lib/features/` – Feature modules (auth, home, profile, etc.)
- `lib/l10n/` – Localization

---

## State Management Approach

- Uses the `provider` package for dependency injection and state management
- Each feature has its own Provider (e.g., `HomeScreenProvider`, `ProfileProvider`)
- Providers are registered in `app.dart` via `MultiProvider`
- Providers manage business logic, data fetching, and notify UI on state changes

---

## Dependency Flow

- UI widgets depend on Providers for state
- Providers depend on Repositories for data access
- Repositories depend on core services (Supabase, Firebase, SharedPrefs)
- Core services are initialized at app startup (`AppInitializer`)

---

## Design Decisions

- **Feature-first structure:** Each feature is self-contained for easier scaling
- **Provider for state:** Chosen for simplicity, reactivity, and testability
- **Supabase for backend:** Real-time updates, authentication, and database
- **Firebase for notifications:** Reliable push notification delivery
- **GoRouter for navigation:** Declarative, type-safe routing
- **Centralized theming and localization:** Ensures consistent UI/UX

---

For a visual data flow and more, see [DATA_FLOW.md](DATA_FLOW.md).
