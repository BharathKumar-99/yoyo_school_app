# Data Flow

## Overview

The YoYo School App follows a clear, layered data flow from user actions to backend and back, supporting both request/response and real-time updates.

---

## Standard Data Flow

```
User Action
  ↓
UI (Widget)
  ↓
Provider (State Logic)
  ↓
Repository (Data Layer)
  ↓
Supabase/API
  ↓
Response
  ↓
Provider updates state
  ↓
UI rebuild
```

---

## Real-Time Updates (Supabase Streams)

```
Backend Change (e.g., new result)
  ↓
Supabase Realtime Channel
  ↓
Repository listens to channel
  ↓
Provider receives stream update
  ↓
Provider updates state
  ↓
UI rebuild
```

---You are a senior software architect and technical documentation expert.

Your task is to analyze the entire codebase and generate COMPLETE production-grade documentation.

IMPORTANT:
- Read and understand ALL relevant files before writing
- Do NOT generate generic explanations
- Infer logic from code
- Be highly structured and detailed
- Assume a new developer will rely ONLY on this documentation

---

OUTPUT FORMAT:
You MUST generate the following files in MARKDOWN format:

1. README.md
2. ARCHITECTURE.md
3. DATA_FLOW.md
4. API_DOCS.md
5. PROVIDER_LIFECYCLE.md
6. FEATURE_FLOWS.md
7. ONBOARDING.md

---

DETAILED REQUIREMENTS:

### 1. README.md
- Project overview
- Features
- Tech stack
- Setup instructions (step-by-step)
- Folder structure summary

---

### 2. ARCHITECTURE.md
- High-level architecture (layered design)
- Folder/module breakdown
- State management approach (Provider)
- Dependency flow between layers
- Design decisions

---

### 3. DATA_FLOW.md
Explain COMPLETE data flow:

- UI → Provider → Repository → Backend → Response → UI
- Include real-time updates (Supabase streams)
- Include text-based diagrams like:

User Action
  ↓
UI (Widget)
  ↓
Provider (State Logic)
  ↓
Repository (Data Layer)
  ↓
Supabase/API
  ↓
Response
  ↓
Provider updates state
  ↓
UI rebuild

---

### 4. API_DOCS.md
- All repositories and backend interactions
- Supabase tables used
- Queries, filters, and operations
- Expected request/response structure
- Model mappings

---

### 5. PROVIDER_LIFECYCLE.md
For EACH provider:

- When it initializes
- What triggers data fetch
- State variables it manages
- When notifyListeners() is called
- Dependencies on other providers
- Disposal/cleanup logic

---

### 6. FEATURE_FLOWS.md
Step-by-step execution flows:

- App startup flow
- Authentication flow (if exists)
- Home screen loading flow
- Profile flow
- Real-time update flow

Each flow should be written like:

Step 1 → Step 2 → Step 3...

---

### 7. ONBOARDING.md
For new developers:

- How to run project
- Important entry points
- Where to start reading code
- Key concepts to understand
- Common pitfalls

---

FINAL RULES:
- Use clean markdown
- Use headings, bullet points, and sections
- Be specific to THIS codebase
- Avoid vague explanations
- Do NOT skip any module
- Do NOT hallucinate — only use code evidence

---

Now analyze the codebase and generate ALL documentation files.

## Example: Fetching Student Classes

1. User opens Home screen
2. `HomeScreenProvider` calls `HomeRepository.getClasses()`
3. Repository queries Supabase for student and class data
4. Data is mapped to models and returned
5. Provider updates state and notifies listeners
6. UI displays updated class info

---

## Example: Real-Time User Results

1. Provider calls `GlobalRepo.streamAllUserResults(ids)`
2. Repository subscribes to Supabase channel for `userResult` table
3. On backend change, Supabase pushes update
4. Repository fetches new data and emits via stream
5. Provider updates state and notifies listeners
6. UI reflects new results instantly

---

## Notes
- All data access is abstracted via repositories
- Providers are the single source of truth for UI state
- Real-time and request/response flows are unified at the provider layer

For API details, see [API_DOCS.md](API_DOCS.md).
