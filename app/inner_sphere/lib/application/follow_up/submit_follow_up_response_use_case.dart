import 'package:uuid/uuid.dart';

import '../../domain/follow_up/follow_up_repository.dart';
import '../../domain/follow_up/follow_up_response.dart';

class SubmitFollowUpResponseUseCase {
  SubmitFollowUpResponseUseCase(this._repository);

  final FollowUpRepository _repository;

  Future<void> submitText({required String promptId, required String responseText}) async {
    await _repository.saveResponse(
      FollowUpResponse(
        id: const Uuid().v4(),
        followUpPromptId: promptId,
        responseType: FollowUpResponseType.text,
        textContent: responseText,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> submitVoiceNote({required String promptId, required String voiceNoteId}) async {
    await _repository.saveResponse(
      FollowUpResponse(
        id: const Uuid().v4(),
        followUpPromptId: promptId,
        responseType: FollowUpResponseType.voiceNote,
        voiceNoteId: voiceNoteId,
        createdAt: DateTime.now(),
      ),
    );
  }
}
