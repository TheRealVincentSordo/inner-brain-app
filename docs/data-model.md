# Data Model

## Overview
The MVP data model focuses on voice note capture, transcript representation, lightweight theme extraction, weighted graph updates, and optional follow-up prompt interactions. All entities are persisted locally.

---

## 1) VoiceNote
### Description
Represents a single recorded voice note created by the user.

### Suggested Fields
- `id` (string/uuid)
- `createdAt` (datetime)
- `durationMs` (int)
- `audioFilePath` (string)
- `audioFormat` (string)
- `transcriptionStatus` (enum: pending, complete, failed)
- `source` (enum: primary_note, follow_up_note)

### Relationships
- One `VoiceNote` has many `TranscriptSegment`.
- One `VoiceNote` has many `ThemeMention`.
- One `VoiceNote` may be linked to zero or one `FollowUpPrompt` context.

---

## 2) TranscriptSegment
### Description
Represents a segment/chunk of transcript text associated with a voice note.

### Suggested Fields
- `id` (string/uuid)
- `voiceNoteId` (fk)
- `index` (int)
- `text` (string)
- `startMs` (int, nullable)
- `endMs` (int, nullable)
- `confidence` (float, nullable)
- `createdAt` (datetime)

### Relationships
- Many `TranscriptSegment` belong to one `VoiceNote`.
- A `TranscriptSegment` can map to many `ThemeMention`.

---

## 3) ThemeNode
### Description
Canonical theme represented as a node in the graph.

### Suggested Fields
- `id` (string/uuid)
- `canonicalName` (string, unique)
- `displayName` (string)
- `totalMentions` (int)
- `pastWeekMentions` (int, cached/derived)
- `weight` (float)
- `lastMentionedAt` (datetime, nullable)
- `createdAt` (datetime)
- `updatedAt` (datetime)

### Relationships
- One `ThemeNode` has many `ThemeMention`.
- One `ThemeNode` participates in many `ThemeEdge` rows (as source or target).

---

## 4) ThemeMention
### Description
Represents one detected mention of a theme from transcript or follow-up response content.

### Suggested Fields
- `id` (string/uuid)
- `voiceNoteId` (fk, nullable when from text-only response)
- `transcriptSegmentId` (fk, nullable)
- `themeNodeId` (fk)
- `rawPhrase` (string)
- `normalizedPhrase` (string)
- `mentionScore` (float)
- `createdAt` (datetime)

### Relationships
- Many `ThemeMention` belong to one `ThemeNode`.
- Many `ThemeMention` may relate to one `VoiceNote`.
- Many `ThemeMention` may relate to one `TranscriptSegment`.

---

## 5) ThemeEdge
### Description
Represents a weighted bi-directional connection between two theme nodes based on co-occurrence.

### Suggested Fields
- `id` (string/uuid)
- `themeAId` (fk to ThemeNode)
- `themeBId` (fk to ThemeNode)
- `coOccurrenceCount` (int)
- `pastWeekCoOccurrenceCount` (int, cached/derived)
- `weight` (float)
- `lastCoOccurredAt` (datetime, nullable)
- `createdAt` (datetime)
- `updatedAt` (datetime)

### Relationships
- Each `ThemeEdge` links exactly two `ThemeNode` entities.
- Edge updates are triggered by grouped `ThemeMention` records from the same voice note or follow-up response.

### Constraint Notes
- Enforce canonical ordering (`themeAId < themeBId`) to prevent duplicate reversed edges.
- Unique index on (`themeAId`, `themeBId`).

---

## 6) FollowUpPrompt
### Description
Represents an optional reflective follow-up prompt generated after processing a voice note.

### Suggested Fields
- `id` (string/uuid)
- `triggerVoiceNoteId` (fk)
- `promptText` (string)
- `promptType` (enum: clarification, expansion, contrast, grounding)
- `shownAt` (datetime)
- `dismissedAt` (datetime, nullable)
- `createdAt` (datetime)

### Relationships
- One `FollowUpPrompt` is associated with one trigger `VoiceNote`.
- One `FollowUpPrompt` can have zero or many `FollowUpResponse` entries.

---

## 7) FollowUpResponse
### Description
Represents user response to a follow-up prompt as text or additional voice note.

### Suggested Fields
- `id` (string/uuid)
- `followUpPromptId` (fk)
- `responseType` (enum: text, voice_note)
- `textContent` (string, nullable)
- `voiceNoteId` (fk, nullable)
- `createdAt` (datetime)

### Relationships
- Many `FollowUpResponse` belong to one `FollowUpPrompt`.
- A voice response links to one `VoiceNote`.
- Response content can produce additional `ThemeMention` records.

---

## Node Weighting Concept
Suggested MVP formula:
- Base node weight derived from total mention count.
- Add recency boost for mentions in last 7 days.

Example:
- `weight = log(1 + totalMentions) + recencyFactor * pastWeekMentions`

Notes:
- Keep weights bounded for stable rendering.
- Normalize to a visual scale before drawing node size/color.

## Edge Weighting Concept
Suggested MVP formula:
- Weight based on co-occurrence count of two themes in same voice note (or follow-up response context).
- Add recency boost similar to nodes.

Example:
- `weight = log(1 + coOccurrenceCount) + recencyFactor * pastWeekCoOccurrenceCount`

Visual mapping:
- Lower weight -> thinner edge, bluer color.
- Higher weight -> thicker edge, redder color.

## Recency Logic for “Past Week” Counts
- Define rolling 7-day window from current local device time.
- On graph refresh or write events, recompute or incrementally update:
  - `ThemeNode.pastWeekMentions`
  - `ThemeEdge.pastWeekCoOccurrenceCount`
- Prefer incremental updates in runtime with periodic reconciliation for consistency.

## Notes on Local Persistence
- Use SQLite tables for entities and indexes on foreign keys, timestamps, and edge pairs.
- Store audio files on local filesystem and reference via `audioFilePath`.
- Apply soft retention options in settings later (future), but keep all data local in MVP.
- Consider optional encryption-at-rest in later milestones if platform-level encryption is insufficient.
