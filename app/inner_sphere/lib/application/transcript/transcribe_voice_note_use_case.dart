import '../../data/native/transcription_platform_bridge.dart';
import '../../domain/transcript/transcript_repository.dart';
import '../../domain/transcript/transcript_segment.dart';
import 'package:uuid/uuid.dart';

class TranscribeVoiceNoteUseCase {
  TranscribeVoiceNoteUseCase(this._bridge, this._transcriptRepository);

  final TranscriptionPlatformBridge _bridge;
  final TranscriptRepository _transcriptRepository;
  final _uuid = const Uuid();

  Future<List<TranscriptSegment>> call(String voiceNoteId, String filePath, String locale) async {
    final lines = await _bridge.transcribeAudio(filePath, locale);
    final now = DateTime.now();
    final segments = <TranscriptSegment>[];
    for (var i = 0; i < lines.length; i++) {
      segments.add(
        TranscriptSegment(
          id: _uuid.v4(),
          voiceNoteId: voiceNoteId,
          index: i,
          text: lines[i],
          createdAt: now,
        ),
      );
    }
    await _transcriptRepository.saveSegments(segments);
    return segments;
  }
}
