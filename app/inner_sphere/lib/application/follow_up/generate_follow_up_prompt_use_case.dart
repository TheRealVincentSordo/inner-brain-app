import 'package:uuid/uuid.dart';

import '../../domain/follow_up/follow_up_prompt.dart';
import '../../domain/follow_up/follow_up_repository.dart';

class GenerateFollowUpPromptUseCase {
  GenerateFollowUpPromptUseCase(this._repository);

  final FollowUpRepository _repository;

  Future<FollowUpPrompt> call(String voiceNoteId, List<String> themes) async {
    final promptText = themes.isEmpty
        ? 'Would you like to add one sentence about how this felt?'
        : 'You mentioned ${themes.first}. What feels most important about it right now?';

    final prompt = FollowUpPrompt(
      id: const Uuid().v4(),
      triggerVoiceNoteId: voiceNoteId,
      promptText: promptText,
      promptType: PromptType.expansion,
      shownAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
    await _repository.savePrompt(prompt);
    return prompt;
  }
}
