import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/follow_up/generate_follow_up_prompt_use_case.dart';
import '../../application/follow_up/submit_follow_up_response_use_case.dart';
import '../../application/theme_graph/theme_extractor.dart';
import '../../application/theme_graph/update_theme_graph_use_case.dart';
import '../../application/transcript/transcribe_voice_note_use_case.dart';
import '../../application/voice_note/record_voice_note_use_case.dart';
import '../../data/follow_up/local_follow_up_repository.dart';
import '../../data/native/transcription_platform_bridge.dart';
import '../../data/services/audio_recording_service.dart';
import '../../data/theme_graph/local_theme_graph_repository.dart';
import '../../data/transcript/local_transcript_repository.dart';
import '../../data/voice_note/local_voice_note_repository.dart';

final voiceNoteRepositoryProvider = Provider((ref) => LocalVoiceNoteRepository());
final transcriptRepositoryProvider = Provider((ref) => LocalTranscriptRepository());
final themeGraphRepositoryProvider = Provider((ref) => LocalThemeGraphRepository());
final followUpRepositoryProvider = Provider((ref) => LocalFollowUpRepository());

final recordVoiceNoteUseCaseProvider = Provider(
  (ref) => RecordVoiceNoteUseCase(AudioRecordingService(), ref.watch(voiceNoteRepositoryProvider)),
);
final transcribeVoiceUseCaseProvider = Provider(
  (ref) => TranscribeVoiceNoteUseCase(TranscriptionPlatformBridge(), ref.watch(transcriptRepositoryProvider)),
);
final updateThemeGraphUseCaseProvider = Provider(
  (ref) => UpdateThemeGraphUseCase(ref.watch(themeGraphRepositoryProvider), ThemeExtractor()),
);
final generatePromptUseCaseProvider = Provider(
  (ref) => GenerateFollowUpPromptUseCase(ref.watch(followUpRepositoryProvider)),
);
final submitResponseUseCaseProvider = Provider(
  (ref) => SubmitFollowUpResponseUseCase(ref.watch(followUpRepositoryProvider)),
);
