# Feature Flows

This document details the step-by-step execution flows for major features in the YoYo School App.

---

## App Startup Flow
1. `main.dart` calls `AppInitializer.initialize()`
2. Initializes Flutter bindings
3. Initializes Firebase (core + messaging)
4. Locks orientation to portrait
5. Sets up Firebase background message handler
6. Initializes Supabase client
7. Initializes notification services
8. Initializes shared preferences
9. Creates `GlobalProvider` (loads remote config)
10. Registers error handlers
11. Sets system UI overlay style
12. Runs app with `RestartWidget` and `MyApp`
13. `MyApp` sets up providers and MaterialApp

---

## Authentication Flow
1. User opens app (not authenticated)
2. Navigated to login screen (`LoginScreen`)
3. User enters credentials
4. `AuthRepository`/`AuthService` validates via Supabase
5. On success, user is routed to onboarding or home
6. Onboarding flow (if first login)
7. User state is updated in `ProfileProvider`

---

## Home Screen Loading Flow
1. Home screen widget is built
2. `HomeScreenProvider` is created (with `HomeRepository`)
3. Provider fetches student classes and levels from Supabase
4. Filters classes/phrases by language level and school config
5. Loads homework and phrase categories
6. Updates state and notifies listeners
7. UI displays dashboard with up-to-date data

---

## Profile Flow
1. `ProfileProvider` subscribes to user data stream on creation
2. On user data change, provider updates state
3. UI reflects new profile info instantly
4. On logout, provider clears state and triggers app restart

---

## Real-Time Update Flow
1. `GlobalProvider` calls `initRealtimeResults(ids)`
2. `GlobalRepo` subscribes to Supabase channel for `userResult`
3. On backend change, Supabase pushes update
4. Repository fetches new results and emits via stream
5. Provider updates state and notifies listeners
6. UI reflects new results in real time

---

For onboarding and developer guidance, see [ONBOARDING.md](ONBOARDING.md).
