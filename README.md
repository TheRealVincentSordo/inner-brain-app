# InnerSphere MVP Bootstrap

This repository contains product and technical documentation for **InnerSphere**, a local-first reflective mobile app concept.

## One-shot Codex Prompt (MVP Build)

Use the prompt below in Codex to scaffold and implement the MVP in one pass.

```text
You are implementing the InnerSphere MVP in this repository.

Context:
- Read the docs in /docs first and follow them as source-of-truth:
  - docs/README.md
  - docs/product-overview.md
  - docs/user-experience.md
  - docs/technical-architecture.md
  - docs/data-model.md
  - docs/mvp-scope.md
  - docs/future-ideas.md (for future-only references; do not add these to MVP)

Build target:
- Flutter mobile app (Android + iOS) at app/inner_sphere.
- Local-first MVP only (no cloud/backend dependency).
- Native transcription via platform channels.
- Local persistence for notes, transcript segments, theme mentions, theme nodes, theme edges, follow-up prompts/responses.
- Interactive graph view rendered as a 3D sphere (MVP-friendly implementation acceptable).

Implementation requirements:
1) Project setup
- Create Flutter project if missing: app/inner_sphere
- Add dependencies for:
  - state management
  - local storage (SQLite)
  - file/audio handling
  - graph math/render support
- Keep dependency set minimal.

2) App architecture
- Implement clean layer structure:
  - lib/presentation
  - lib/application
  - lib/domain
  - lib/data
- Add feature subfolders:
  - voice_note
  - transcript
  - theme_graph
  - follow_up

3) Domain/data model
- Implement entities aligned to docs:
  - VoiceNote
  - TranscriptSegment
  - ThemeNode
  - ThemeMention
  - ThemeEdge
  - FollowUpPrompt
  - FollowUpResponse
- Add repository interfaces + local implementations.
- Implement SQLite schema + migrations for MVP entities.

4) Voice note + transcription
- Build voice note recording flow.
- Persist recorded audio locally.
- Implement platform channel contract:
  - transcribeAudio(filePath, locale)
  - isOnDeviceTranscriptionAvailable(locale)
- Add Android and iOS bridge stubs with clear TODOs for native integration.

5) Theme extraction (MVP)
- Implement lightweight local tagging (rule/lexicon based).
- Normalize tags to canonical theme names.
- Persist ThemeMention records.
- Update ThemeNode and ThemeEdge weights.
- Implement past-week count logic (rolling 7-day window).

6) Graph visualization
- Implement graph screen with rotatable sphere interaction.
- Encode node weight by size/intensity.
- Encode edge weight by thickness and color (blue -> red).
- Support node long-press detail modal showing:
  - theme name
  - count in past week
  - strongest connections
  - connection strengths

7) Follow-up prompts
- After transcript + theme update, optionally show follow-up prompt.
- Accept response as text or additional voice note.
- Feed response back into local theme extraction/update pipeline.

8) UX and screens (MVP)
- Implement minimum screens:
  - Home/Graph
  - Record Voice Note
  - Transcript Review
  - Theme Review
  - Follow-Up Prompt
  - Node Detail Overlay
- Keep copy and interactions reflective, calm, and minimal.

9) Local deployment and docs
- Update root README with:
  - setup/install prerequisites
  - how to run locally
  - how to build debug artifacts
- Add concise developer notes for platform-channel files.

10) Validation
- Run:
  - dart format .
  - flutter analyze
  - flutter test (if tests added)
- Fix lint/analyze issues introduced by this implementation.

Output requirements:
- Commit all changes.
- Provide a short implementation summary mapped to MVP milestones.
- List exact commands run for setup, analysis, and local execution.
```

## Prerequisites

Install and verify the following:

- Flutter SDK (stable)
- Dart SDK (bundled with Flutter)
- Xcode (for iOS builds on macOS)
- Android Studio + Android SDK (for Android builds)

Verify environment:

```bash
flutter --version
dart --version
flutter doctor
```

## Local deployment steps (after implementation)

### 1) Enter app directory

```bash
cd app/inner_sphere
```

### 2) Fetch packages

```bash
flutter pub get
```

### 3) Run on local simulator/device

```bash
flutter run
```

### 4) Build installable artifacts (optional)

Android debug APK:

```bash
flutter build apk --debug
```

iOS debug build (macOS only):

```bash
flutter build ios --debug
```

## Documentation index

Product/spec documentation is available under [`docs/`](./docs):

- [`docs/README.md`](./docs/README.md)
- [`docs/product-overview.md`](./docs/product-overview.md)
- [`docs/user-experience.md`](./docs/user-experience.md)
- [`docs/technical-architecture.md`](./docs/technical-architecture.md)
- [`docs/data-model.md`](./docs/data-model.md)
- [`docs/mvp-scope.md`](./docs/mvp-scope.md)
- [`docs/future-ideas.md`](./docs/future-ideas.md)
