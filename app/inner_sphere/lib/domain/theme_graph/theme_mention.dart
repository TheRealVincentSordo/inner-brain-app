class ThemeMention {
  const ThemeMention({
    required this.id,
    required this.themeNodeId,
    required this.rawPhrase,
    required this.normalizedPhrase,
    required this.mentionScore,
    required this.createdAt,
    this.voiceNoteId,
    this.transcriptSegmentId,
  });

  final String id;
  final String? voiceNoteId;
  final String? transcriptSegmentId;
  final String themeNodeId;
  final String rawPhrase;
  final String normalizedPhrase;
  final double mentionScore;
  final DateTime createdAt;
}
