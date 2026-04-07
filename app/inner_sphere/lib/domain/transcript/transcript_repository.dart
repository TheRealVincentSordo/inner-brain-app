import 'transcript_segment.dart';

abstract class TranscriptRepository {
  Future<void> saveSegments(List<TranscriptSegment> segments);
  Future<List<TranscriptSegment>> segmentsForVoiceNote(String voiceNoteId);
}
