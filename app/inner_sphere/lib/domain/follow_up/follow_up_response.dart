enum FollowUpResponseType { text, voiceNote }

class FollowUpResponse {
  const FollowUpResponse({
    required this.id,
    required this.followUpPromptId,
    required this.responseType,
    required this.createdAt,
    this.textContent,
    this.voiceNoteId,
  });

  final String id;
  final String followUpPromptId;
  final FollowUpResponseType responseType;
  final String? textContent;
  final String? voiceNoteId;
  final DateTime createdAt;
}
