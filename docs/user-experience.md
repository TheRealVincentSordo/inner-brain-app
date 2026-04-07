# User Experience

## UX Goals
- Make reflection capture effortless through voice note recording.
- Provide understandable transcript and theme outputs.
- Visualize the inner-world graph in a way that feels exploratory, not analytical-heavy.
- Keep interactions calm, private, and non-judgmental.

## Main User Flow
1. User opens app and lands on Home with the 3D sphere.
2. User taps the primary action button to record a voice note.
3. User records, pauses, and saves the voice note.
4. App runs native transcription and displays transcript output.
5. App performs local theme extraction and shows detected themes.
6. User confirms and updates graph.
7. User rotates/explores 3D sphere.
8. User long-presses a node to inspect detail.
9. App may show optional follow-up prompt.
10. User answers via text or additional voice note (optional).

## Voice Note Flow
- **Entry point:** Home screen primary action.
- **Recording states:** idle, recording, paused, stopped, saved.
- **Controls:** start, pause/resume, discard, save.
- **Feedback:** waveform animation, elapsed time, subtle haptic/audio confirmation on save.
- **Error handling:** microphone permission guidance and clear retry action.

## Transcription Flow
- After save, app invokes platform bridge to native transcription service.
- UI displays "Transcribing…" state.
- On success:
  - Show transcript in readable segmented format.
  - Allow quick correction (optional lightweight edit in MVP).
- On failure:
  - Show actionable message.
  - Offer retry or continue without transcript (if recording retained).

## Theme Extraction Flow
- Run local lightweight tagging on transcript.
- Normalize terms to canonical theme names.
- Present extracted theme list with confidence-light indicators (optional in MVP).
- Allow user to deselect irrelevant themes before commit.
- On confirmation:
  - Update node weights.
  - Update edge weights based on co-occurrence.
  - Persist all updates locally.

## Follow-Up Prompt Flow
- Trigger condition: after transcript + theme extraction commit.
- Prompt style: short, reflective, and optional.
- User options:
  - skip,
  - answer in text,
  - answer with additional voice note.
- Responses feed back into transcript/theme pipeline (if voice note) or direct text tagging pipeline.

## 3D Sphere Interaction Flow
- Default graph view is a rotatable 3D sphere.
- User can:
  - drag to rotate,
  - pinch to zoom,
  - tap node to highlight immediate edges,
  - toggle visual intensity legend.
- Visual encoding:
  - node size/intensity maps to theme weight,
  - edge thickness and color maps to edge weight,
  - cold-to-hot gradient from blue (low) to red (high).

## Node Long-Press Detail Behavior
On long-press of a node, show a detail card/modal with:
- Theme name.
- Appearances in the past week.
- Top strongest connected themes.
- Connection strengths for each top edge.
- Quick actions:
  - highlight connected nodes,
  - close detail,
  - optionally rename/merge (future, not MVP).

## Suggested MVP Screens
1. **Home / Graph Screen**
   - 3D sphere, quick stats, record action.
2. **Record Voice Note Screen**
   - recording controls and state feedback.
3. **Transcript Review Screen**
   - transcript display, retry, proceed.
4. **Theme Review Screen**
   - extracted theme chips/list, confirm action.
5. **Follow-Up Prompt Screen**
   - optional text or voice response.
6. **Node Detail Overlay**
   - long-press detail panel from graph screen.

## Tone, Feel, and Interaction Style
- **Tone:** calm, warm, and reflective.
- **Language:** simple and non-clinical.
- **Interaction:** soft transitions, minimal interruption, clear focus states.
- **Privacy signaling:** explicit local-first messaging in onboarding and settings.
- **Cadence:** encourage frequent use without pressure or streak mechanics in MVP.
