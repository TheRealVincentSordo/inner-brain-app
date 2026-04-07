enum PromptType { clarification, expansion, contrast, grounding }

class FollowUpPrompt {
  const FollowUpPrompt({
    required this.id,
    required this.triggerVoiceNoteId,
    required this.promptText,
    required this.promptType,
    required this.shownAt,
    required this.createdAt,
    this.dismissedAt,
  });

  final String id;
  final String triggerVoiceNoteId;
  final String promptText;
  final PromptType promptType;
  final DateTime shownAt;
  final DateTime? dismissedAt;
  final DateTime createdAt;
}
