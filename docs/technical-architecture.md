# Technical Architecture (MVP)

## Architecture Goals
- Deliver a production-lean MVP fully on-device.
- Keep implementation maintainable with clear separation of concerns.
- Support incremental evolution toward richer local intelligence.

## High-Level MVP Architecture
- **Client-only Flutter app** with platform-specific bridges.
- **No backend dependency** for core workflows.
- **Local persistence only** for voice notes, transcript data, theme graph, and follow-up prompt data.

## Flutter App Structure
Suggested package-by-feature + clean layers hybrid:

- `lib/presentation/`
  - screens, widgets, view models/state notifiers.
- `lib/application/`
  - use-cases and orchestration logic.
- `lib/domain/`
  - entities, repository interfaces, domain services.
- `lib/data/`
  - local repositories, DTOs, mappers, persistence adapters, native bridge adapters.

Optional feature grouping inside each layer:
- `voice_note/`
- `transcript/`
- `theme_graph/`
- `follow_up/`

## Native Platform Bridge for Transcription
Use Flutter platform channels (or FFI if needed later) to call native transcription services.

- **iOS:** bridge to `Speech` framework APIs for on-device speech recognition where supported.
- **Android:** bridge to platform speech recognition APIs with on-device preference when available.

Bridge contract example:
- `transcribeAudio(filePath, locale) -> TranscriptResult`
- `isOnDeviceTranscriptionAvailable(locale) -> bool`

Fallback behavior:
- If on-device mode unavailable for locale/device, either:
  - warn user and disable transcription-based flow, or
  - allow manual transcript entry.

## Local-Only Data Architecture
- Repository pattern with local implementations.
- Event-driven updates in app state when processing pipeline completes.
- Data flow for one voice note:
  1. Record and save file locally.
  2. Generate transcript via native bridge.
  3. Run local theme extraction.
  4. Update theme nodes and theme edges.
  5. Persist aggregate graph updates.
  6. Refresh 3D sphere view model.

## Suggested Layers and Responsibilities
### Presentation
- UI rendering, state handling, interaction events.
- No direct persistence or native API calls.

### Application / Use-Cases
- `RecordVoiceNoteUseCase`
- `TranscribeVoiceNoteUseCase`
- `ExtractThemesUseCase`
- `UpdateThemeGraphUseCase`
- `GenerateFollowUpPromptUseCase`
- `SubmitFollowUpResponseUseCase`

### Domain
- Entities (`VoiceNote`, `ThemeNode`, `ThemeEdge`, etc.).
- Domain policies (normalization rules, weighting rules).
- Repository interfaces.

### Data
- Local storage adapters.
- Native transcription bridge adapters.
- Lightweight tagging implementation.
- Serialization/mapping between domain and persistence models.

## Local Storage Recommendation
Recommended MVP approach:
- **SQLite (via Drift or sqflite)** for structured relational graph and history data.
- **File system storage** for raw audio files.

Why:
- Strong fit for relational entities and weighted edges.
- Reliable querying for "past week" counts and top connections.
- Works offline and scales better than key-value only stores for graph-like queries.

## Theme Extraction Pipeline (MVP)
MVP should use lightweight local tagging, not deep AI inference.

Proposed pipeline:
1. Normalize transcript text (lowercasing, punctuation cleanup).
2. Sentence/phrase segmentation.
3. Rule-based or lexicon-based theme matching.
4. Canonicalization to known theme names (e.g., "work stress" and "job pressure" -> "work pressure").
5. Score mention strength by frequency + position heuristics.
6. Persist `ThemeMention` records.
7. Recompute impacted node and edge weights.

## Graph Rendering Approach for 3D Sphere
Options in Flutter MVP:
- Use a 3D-capable rendering package (OpenGL/SceneKit bridge or Flutter-friendly 3D engine).
- Or emulate depth with projected 2D coordinates and interaction transforms for faster MVP delivery.

Practical MVP recommendation:
- Start with a performant pseudo-3D implementation if true 3D package risk is high.
- Preserve a renderer abstraction so engine can be swapped later.

Visual encoding:
- Node size/color intensity -> node weight.
- Edge thickness + blue-to-red color scale -> edge weight.

## Tradeoffs and Technical Risks
- **Platform transcription variability:** quality and on-device support differ by device/locale.
- **3D performance risk:** graph rendering can be heavy on low-end devices.
- **Theme quality risk:** lightweight tagging may underfit nuanced transcript meaning.
- **Storage growth:** long-term audio retention increases local footprint.
- **UX complexity risk:** graph interactions can confuse users without careful onboarding.

## Explicit MVP Constraint
The MVP intentionally uses **lightweight local tagging** for theme extraction and normalization. It does **not** include deep AI inference, cloud LLM processing, or remote model hosting.
