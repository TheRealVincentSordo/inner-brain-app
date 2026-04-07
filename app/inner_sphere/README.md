# InnerSphere Flutter App (MVP)

## Platform channel developer notes

Transcription bridge method channel: `inner_sphere/transcription`

Implemented contract:
- `transcribeAudio(filePath, locale)` -> `List<String>` transcript segments
- `isOnDeviceTranscriptionAvailable(locale)` -> `bool`

Native integration files:
- Android: `android/app/src/main/kotlin/com/example/inner_sphere/MainActivity.kt`
- iOS: `ios/Runner/AppDelegate.swift`

Both files currently include TODO stubs that return fallback values for MVP scaffolding.
