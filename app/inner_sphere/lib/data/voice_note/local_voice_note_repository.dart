import '../../domain/voice_note/voice_note.dart';
import '../../domain/voice_note/voice_note_repository.dart';
import '../db/app_database.dart';

class LocalVoiceNoteRepository implements VoiceNoteRepository {
  @override
  Future<List<VoiceNote>> listVoiceNotes() async {
    final db = await AppDatabase.open();
    final rows = await db.query('voice_notes', orderBy: 'created_at DESC');
    return rows
        .map(
          (row) => VoiceNote(
            id: row['id'] as String,
            createdAt: DateTime.parse(row['created_at'] as String),
            durationMs: row['duration_ms'] as int,
            audioFilePath: row['audio_file_path'] as String,
            audioFormat: row['audio_format'] as String,
            transcriptionStatus: TranscriptionStatus.values.byName(row['transcription_status'] as String),
            source: VoiceNoteSource.values.byName(row['source'] as String),
          ),
        )
        .toList();
  }

  @override
  Future<void> saveVoiceNote(VoiceNote note) async {
    final db = await AppDatabase.open();
    await db.insert('voice_notes', {
      'id': note.id,
      'created_at': note.createdAt.toIso8601String(),
      'duration_ms': note.durationMs,
      'audio_file_path': note.audioFilePath,
      'audio_format': note.audioFormat,
      'transcription_status': note.transcriptionStatus.name,
      'source': note.source.name,
    });
  }
}
