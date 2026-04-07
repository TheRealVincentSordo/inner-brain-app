# InnerSphere MVP

InnerSphere is a local-first reflective mobile app that turns voice notes into an evolving theme graph.

## Prerequisites

- Flutter SDK (stable)
- Dart SDK (bundled with Flutter)
- Android Studio + Android SDK (Android)
- Xcode + CocoaPods (iOS on macOS)

Verify tooling:

```bash
flutter --version
dart --version
flutter doctor
```

## Project layout

- Product and technical docs: `docs/`
- Flutter app: `app/inner_sphere`

## Run locally

```bash
cd app/inner_sphere
flutter pub get
flutter run
```

## Build debug artifacts

Android debug APK:

```bash
cd app/inner_sphere
flutter build apk --debug
```

iOS debug build (macOS only):

```bash
cd app/inner_sphere
flutter build ios --debug
```

## Validation commands

```bash
cd app/inner_sphere
dart format .
flutter analyze
flutter test
```

## Platform channel notes

See `app/inner_sphere/README.md` for native transcription bridge contract and file-level implementation notes.
