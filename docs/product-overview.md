# Product Overview

## Problem Statement
People capture many thoughts in voice notes, but those notes often become isolated fragments that are difficult to revisit, connect, or understand over time. Existing tools are typically productivity-oriented and list-based, making it hard to identify recurring emotional or cognitive patterns. Users need a private, low-friction way to observe how their inner themes evolve.

## Product Vision
Create a local-first reflective app that turns raw voice notes into a living map of inner themes. The app should help users move from isolated entries to meaningful pattern awareness through a visual and intuitive 3D sphere graph.

## Core Concept
1. User records a voice note.
2. App generates a transcript using the phone’s native transcription capability.
3. App extracts lightweight, normalized themes from the transcript locally.
4. Themes become nodes in a weighted bi-directional graph.
5. Theme intersections become edges with dynamic strength.
6. Graph is displayed as an interactive 3D sphere.
7. User can optionally answer a follow-up prompt in text or a new voice note.

## What Makes This App Unique
- **Local-first by design:** Sensitive reflection data remains on-device in the MVP.
- **Reflective orientation:** Focuses on self-understanding rather than task completion.
- **Pattern mapping, not just archiving:** Turns transcript content into an evolving theme graph.
- **Intuitive visual model:** A 3D sphere makes recurring themes and connections easy to perceive.
- **Lightweight intelligence in MVP:** Practical local tagging without overreaching into heavy inference.

## Primary User Journey
1. Open app and see current 3D sphere snapshot.
2. Tap record and capture a voice note.
3. Review generated transcript.
4. Confirm or accept extracted themes.
5. View updated graph where node and edge weights reflect new data.
6. Long-press node to inspect details (past-week count and strongest connections).
7. Optionally respond to a follow-up prompt.
8. Return later to observe evolving patterns.

## Guiding Product Principles
- **Local-first:** Keep data processing and storage on-device in the MVP.
- **Reflective, not just productive:** Prioritize insight and emotional clarity over output metrics.
- **Psychologically meaningful but lightweight in MVP:** Use simple theme extraction and clear summaries.
- **Visual and intuitive:** Present complexity through interactions users can understand quickly.
- **Low friction:** Voice-first capture should be fast enough for daily use.
- **User agency:** Follow-up prompt is optional and non-intrusive.
