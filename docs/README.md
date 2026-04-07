# InnerSphere (Project Name Suggestion)

## Summary
InnerSphere is a local-first reflective mobile app that helps users transform voice notes into an evolving inner-world graph. Each voice note is transcribed on-device, converted into lightweight normalized themes, and mapped into a weighted bi-directional graph shown as an interactive 3D sphere. The app is designed to support reflection, pattern recognition, and emotional self-awareness without requiring any cloud dependency in the MVP.

## Key Concepts
- **Voice note capture:** Fast, low-friction recording of personal reflections.
- **On-device transcript generation:** Use native iOS and Android transcription services via platform bridges.
- **Lightweight local theme extraction:** Convert transcript content into reusable higher-level themes.
- **Weighted graph model:** Themes are represented as nodes; intersections are represented as edges.
- **3D sphere visualization:** Explore connections through rotation, node inspection, and visual weight cues.
- **Reflective follow-up prompt:** Optional lightweight prompts after transcription to deepen reflection.
- **Local-first MVP:** No backend or cloud processing required.

## Documentation Index
- [`product-overview.md`](./product-overview.md)  
  Product vision, problem statement, differentiators, and guiding principles.
- [`user-experience.md`](./user-experience.md)  
  End-to-end user flow, interaction design, and suggested MVP screens.
- [`technical-architecture.md`](./technical-architecture.md)  
  Flutter architecture, native transcription bridges, local processing, and technical risks.
- [`data-model.md`](./data-model.md)  
  Core entities, relationships, weighting logic, and local persistence notes.
- [`mvp-scope.md`](./mvp-scope.md)  
  Clear in-scope and out-of-scope boundaries, assumptions, risks, and milestones.
- [`future-ideas.md`](./future-ideas.md)  
  Potential expansions beyond MVP, including richer local AI and advanced graph experiences.
