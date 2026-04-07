enum TranscriptionStatus { pending, complete, failed }
enum VoiceNoteSource { primaryNote, followUpNote }

class VoiceNote {
  const VoiceNote({
    required this.id,
    required this.createdAt,
    required this.durationMs,
    required this.audioFilePath,
    required this.audioFormat,
    required this.transcriptionStatus,
    required this.source,
  });

  final String id;
  final DateTime createdAt;
  final int durationMs;
  final String audioFilePath;
  final String audioFormat;
  final TranscriptionStatus transcriptionStatus;
  final VoiceNoteSource source;
}
