class TranscriptSegment {
  const TranscriptSegment({
    required this.id,
    required this.voiceNoteId,
    required this.index,
    required this.text,
    required this.createdAt,
    this.startMs,
    this.endMs,
    this.confidence,
  });

  final String id;
  final String voiceNoteId;
  final int index;
  final String text;
  final int? startMs;
  final int? endMs;
  final double? confidence;
  final DateTime createdAt;
}
