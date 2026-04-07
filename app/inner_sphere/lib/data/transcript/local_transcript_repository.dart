import '../../domain/transcript/transcript_repository.dart';
import '../../domain/transcript/transcript_segment.dart';
import '../db/app_database.dart';

class LocalTranscriptRepository implements TranscriptRepository {
  @override
  Future<List<TranscriptSegment>> segmentsForVoiceNote(String voiceNoteId) async {
    final db = await AppDatabase.open();
    final rows = await db.query(
      'transcript_segments',
      where: 'voice_note_id = ?',
      whereArgs: [voiceNoteId],
      orderBy: 'segment_index ASC',
    );
    return rows
        .map(
          (row) => TranscriptSegment(
            id: row['id'] as String,
            voiceNoteId: row['voice_note_id'] as String,
            index: row['segment_index'] as int,
            text: row['text'] as String,
            startMs: row['start_ms'] as int?,
            endMs: row['end_ms'] as int?,
            confidence: (row['confidence'] as num?)?.toDouble(),
            createdAt: DateTime.parse(row['created_at'] as String),
          ),
        )
        .toList();
  }

  @override
  Future<void> saveSegments(List<TranscriptSegment> segments) async {
    final db = await AppDatabase.open();
    final batch = db.batch();
    for (final segment in segments) {
      batch.insert('transcript_segments', {
        'id': segment.id,
        'voice_note_id': segment.voiceNoteId,
        'segment_index': segment.index,
        'text': segment.text,
        'start_ms': segment.startMs,
        'end_ms': segment.endMs,
        'confidence': segment.confidence,
        'created_at': segment.createdAt.toIso8601String(),
      });
    }
    await batch.commit(noResult: true);
  }
}
