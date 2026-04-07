# InnerSphere MVP Bootstrap

This repository contains product and technical documentation for **InnerSphere**, a local-first reflective mobile app concept, plus a **one-shot Codex setup script** that scaffolds an MVP Flutter implementation.

## What this script does

The script `scripts/codex_one_shot_mvp.sh` bootstraps a runnable Flutter MVP skeleton aligned with the docs:

- Creates `app/inner_sphere` Flutter app (Android + iOS).
- Adds core dependencies for local MVP development.
- Creates clean architecture folders:
  - `presentation`
  - `application/use_cases`
  - `domain/entities`
  - `data/adapters`
- Adds starter files for:
  - App entrypoint
  - Domain entities (`VoiceNote`, `ThemeNode`, `ThemeEdge`)
  - Native transcription platform-channel bridge
  - Lightweight local theme extraction use-case
  - Graph screen placeholder
- Runs formatting and static analysis.

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

## One-shot setup and installation

From repository root:

```bash
bash scripts/codex_one_shot_mvp.sh
```

Optional: run app immediately after setup.

```bash
bash scripts/codex_one_shot_mvp.sh --run
```

## Local deployment steps

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

## Recommended MVP implementation order

1. Voice note capture + permissions.
2. Native transcript bridge implementation in iOS/Android code.
3. Local transcript persistence.
4. Lightweight local theme extraction and normalization.
5. Node/edge weighting + local storage.
6. 3D sphere graph renderer and node long-press detail.
7. Follow-up prompt flow (text or voice response).

## Documentation index

Product/spec documentation is available under [`docs/`](./docs):

- [`docs/README.md`](./docs/README.md)
- [`docs/product-overview.md`](./docs/product-overview.md)
- [`docs/user-experience.md`](./docs/user-experience.md)
- [`docs/technical-architecture.md`](./docs/technical-architecture.md)
- [`docs/data-model.md`](./docs/data-model.md)
- [`docs/mvp-scope.md`](./docs/mvp-scope.md)
- [`docs/future-ideas.md`](./docs/future-ideas.md)
