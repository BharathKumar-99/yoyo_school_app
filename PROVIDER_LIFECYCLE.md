# Provider Lifecycle

This document details the lifecycle, state, dependencies, and cleanup logic for each Provider in the YoYo School App.

---

## GlobalProvider
- **Initialization:**
  - Created in `AppInitializer.initialize()` (startup)
  - Instantiated via `GlobalProvider.create()` (async, loads remote config)
- **Data Fetch Triggers:**
  - On creation (loads remote config)
  - `initRealtimeResults(List<int> phraseIds)` subscribes to real-time user results
  - `reInitialize()` reloads remote config
- **State Variables:**
  - `results` (List<UserResult>)
  - `version`, `code`, `apiCred` (RemoteConfig)
  - `_isLoading` (bool)
- **notifyListeners():**
  - After state changes (e.g., new results, config reload)
- **Dependencies:**
  - Uses `GlobalRepo` for all data access
- **Disposal:**
  - Cancels result stream and disposes repo stream in `dispose()`

---

## ProfileProvider
- **Initialization:**
  - Created in `app.dart` via `ChangeNotifierProvider`
  - Calls `initialize()` to subscribe to user data stream
- **Data Fetch Triggers:**
  - On creation (subscribes to user data)
  - On profile changes (stream emits new data)
- **State Variables:**
  - `user` (UserModel?)
  - `school` (School?)
  - `isLoading` (bool)
  - `nameFromUser` (String?)
- **notifyListeners():**
  - After user data changes
- **Dependencies:**
  - Uses `ProfileRepository` for all data access
- **Disposal:**
  - Cancels user data stream in `dispose()`

---

## HomeScreenProvider
- **Initialization:**
  - Created in `app.dart` via `ChangeNotifierProvider`
  - Instantiates with `HomeRepository`
- **Data Fetch Triggers:**
  - On creation (fetches profile and home data)
  - On demand via methods (e.g., `getDetails()`)
- **State Variables:**
  - `levels`, `userClases`, `student`, `school`, `homeWorkModel`, `userDetailsModel`, etc.
- **notifyListeners():**
  - After data fetches and state changes
- **Dependencies:**
  - Uses `HomeRepository` for all data access
  - Reads from `ProfileProvider` and `GlobalProvider` for cross-feature state
- **Disposal:**
  - Cancels student subscription in `dispose()`

---

For feature flows, see [FEATURE_FLOWS.md](FEATURE_FLOWS.md).
