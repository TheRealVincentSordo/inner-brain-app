import 'voice_note.dart';

abstract class VoiceNoteRepository {
  Future<void> saveVoiceNote(VoiceNote note);
  Future<List<VoiceNote>> listVoiceNotes();
}
