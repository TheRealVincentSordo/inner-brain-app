# MVP Scope

## MVP Goals
- Prove that users can convert voice notes into a meaningful evolving theme graph.
- Deliver a smooth local-first loop: record -> transcript -> themes -> 3D sphere.
- Validate whether optional follow-up prompt interactions deepen reflection.

## In-Scope Features (MVP)
- Voice note recording in Flutter app.
- Native on-device transcription integration through platform bridges.
- Transcript review and basic correction.
- Lightweight local theme extraction and normalization.
- Theme node and theme edge persistence in local storage.
- Weighted graph visualization in interactive 3D sphere view.
- Node long-press details:
  - theme name,
  - past week mention count,
  - strongest connections,
  - connection strengths.
- Optional follow-up prompt with text or voice response.
- Fully local-first architecture with no backend requirement.

## Out-of-Scope Features (MVP)
- Cloud sync or multi-device account system.
- Remote AI/LLM inference.
- Advanced semantic understanding or deep psychological profiling.
- Social sharing and collaborative spaces.
- Therapist or coach integration.
- Gamification systems (streaks, badges, etc.).
- Full manual graph editing tools (e.g., complex merge/split UX).
- Rich analytics dashboards beyond core graph and node details.

## Assumptions
- Users grant microphone permissions.
- Target devices support acceptable local transcription quality.
- Lightweight tagging is sufficient to surface recurring themes for initial validation.
- Early users prioritize privacy and reflection over exhaustive AI accuracy.

## Risks
- Inconsistent transcription quality across devices/locales.
- Theme extraction may produce noisy or overly generic theme labels.
- 3D sphere performance or legibility challenges on smaller screens.
- Users may need onboarding to interpret node/edge meaning.

## Suggested Milestone Breakdown

### Milestone 1: Recording + Transcription
- Implement voice note recording workflow.
- Save local audio files.
- Add iOS/Android transcription bridge.
- Render transcript review UI.
- Exit criteria: user can reliably record and obtain transcript locally.

### Milestone 2: Local Theme Extraction + Persistence
- Implement transcript normalization and theme tagging pipeline.
- Create local schema for voice note, transcript, theme mention, node, and edge.
- Persist and query node/edge weights and recency counts.
- Exit criteria: new transcript updates durable theme graph state.

### Milestone 3: Graph Visualization
- Implement 3D sphere graph view with interaction (rotate/zoom/highlight).
- Map node and edge weights to visual properties.
- Add node long-press detail panel.
- Exit criteria: user can explore and understand key recurring themes and connections.

### Milestone 4: Follow-Up Prompts
- Add optional prompt generation after theme update.
- Support text response and voice note response flow.
- Feed response content back into theme graph update pipeline.
- Exit criteria: follow-up prompt loop works end-to-end locally.

## MVP Success Signals
- Users can complete the full loop without confusion.
- Graph visibly evolves after repeated entries.
- Node detail panel surfaces coherent, trusted summaries.
- Follow-up prompt feature has meaningful voluntary engagement.
