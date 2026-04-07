import 'package:uuid/uuid.dart';

import '../../data/services/audio_recording_service.dart';
import '../../domain/voice_note/voice_note.dart';
import '../../domain/voice_note/voice_note_repository.dart';

class RecordVoiceNoteUseCase {
  RecordVoiceNoteUseCase(this._service, this._repository);

  final AudioRecordingService _service;
  final VoiceNoteRepository _repository;
  final _uuid = const Uuid();

  Future<bool> hasPermission() => _service.hasPermission();
  Future<String> start() => _service.start();
  Future<void> pause() => _service.pause();
  Future<void> resume() => _service.resume();

  Future<VoiceNote?> stopAndSave({
    required DateTime startedAt,
    required VoiceNoteSource source,
  }) async {
    final filePath = await _service.stop();
    if (filePath == null) return null;
    final note = VoiceNote(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      durationMs: DateTime.now().difference(startedAt).inMilliseconds,
      audioFilePath: filePath,
      audioFormat: 'm4a',
      transcriptionStatus: TranscriptionStatus.pending,
      source: source,
    );
    await _repository.saveVoiceNote(note);
    return note;
  }
}
