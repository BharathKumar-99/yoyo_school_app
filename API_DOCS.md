# API Documentation

## Overview
This document details all repository classes, backend interactions, Supabase tables, queries, and model mappings in the YoYo School App.

---

## Repositories & Backend Interactions

### GlobalRepo
- **Supabase Tables:** `userResult`, `remoteConfig`, `phraseDisabledSchools`, `pronunciationFeedbackTemplates`, `streakTable`
- **Key Methods:**
  - `streamAllUserResults(List<int> ids)`: Streams real-time user results for given phrase IDs
  - `getRemoteCred()`: Fetches remote config for the user's school
  - `callSuperSpeechApi(...)`: Calls external speech evaluation API
  - `getRandomFeedback(int score)`: Fetches random feedback template from Supabase
  - `getSpeechFeedback(SpeechEvaluationModel data)`: Calls OpenAI API for feedback
  - `updateStreak(...)`: Updates user streak in Supabase

### HomeRepository
- **Supabase Tables:** `level`, `student`, `users`, `userResult`, `studentClasses`, `classes`, `language`, `phrase`, `attemptedPhrases`, `phraseCategories`, `homework`
- **Key Methods:**
  - `getLevel()`: Fetches all levels
  - `getClasses()`: Fetches student classes, filters by language level, and allowed phrases
  - `getAllPhraseCategories(int langId, int schoolId)`: Fetches phrase categories for a language and school
  - `fetchStudents()`: Fetches student data for current user

### ProfileRepository
- **Supabase Tables:** `users`, `school`
- **Key Methods:**
  - `logout(...)`: Updates user status, clears local storage, signs out
  - `getSchoolData(int id)`: Fetches school data by ID
  - `getUserDataStream()`: Streams user data for real-time profile updates

---

## Supabase Table Usage

- **userResult**: Stores user results for phrase practice; supports real-time streaming
- **remoteConfig**: Stores per-school configuration, including disabled phrases
- **phraseDisabledSchools**: Maps disabled phrases to schools
- **pronunciationFeedbackTemplates**: Stores feedback templates for score ranges
- **streakTable**: Tracks user streaks by language
- **level, student, users, studentClasses, classes, language, phrase, attemptedPhrases, phraseCategories, homework**: Core educational data

---

## Query/Response Examples

### Fetching User Results
```dart
_client.from(DbTable.userResult)
  .select()
  .eq('score_submited', true)
  .inFilter('phrases_id', ids);
```
- **Response:** List of user result rows, mapped to `UserResult` model

### Streaming Real-Time Updates
```dart
_userResultChannel = _client.channel('user_result_updates');
_userResultChannel.onPostgresChanges(...)
```
- **Response:** On change, fetches new data and emits via stream

### Fetching Student Classes
```dart
_client.from(DbTable.student)
  .select('...')
  .eq('user_id', userId)
  .maybeSingle();
```
- **Response:** Nested student, user, class, and phrase data, mapped to `Student` and related models

---

## Model Mappings
- All JSON responses are mapped to Dart models via `fromJson` constructors (e.g., `UserResult.fromJson`, `PhraseModel.fromJson`, `UserModel.fromJson`)
- Nested relationships are handled in model constructors

---

For provider lifecycle and feature flows, see [PROVIDER_LIFECYCLE.md](PROVIDER_LIFECYCLE.md) and [FEATURE_FLOWS.md](FEATURE_FLOWS.md).
