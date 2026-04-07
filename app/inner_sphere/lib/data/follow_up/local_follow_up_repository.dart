import '../../domain/follow_up/follow_up_prompt.dart';
import '../../domain/follow_up/follow_up_repository.dart';
import '../../domain/follow_up/follow_up_response.dart';
import '../db/app_database.dart';

class LocalFollowUpRepository implements FollowUpRepository {
  @override
  Future<FollowUpPrompt?> latestPrompt() async {
    final db = await AppDatabase.open();
    final rows = await db.query('follow_up_prompts', orderBy: 'created_at DESC', limit: 1);
    if (rows.isEmpty) return null;
    final row = rows.first;
    return FollowUpPrompt(
      id: row['id'] as String,
      triggerVoiceNoteId: row['trigger_voice_note_id'] as String,
      promptText: row['prompt_text'] as String,
      promptType: PromptType.values.byName(row['prompt_type'] as String),
      shownAt: DateTime.parse(row['shown_at'] as String),
      dismissedAt: row['dismissed_at'] == null ? null : DateTime.parse(row['dismissed_at'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  @override
  Future<void> savePrompt(FollowUpPrompt prompt) async {
    final db = await AppDatabase.open();
    await db.insert('follow_up_prompts', {
      'id': prompt.id,
      'trigger_voice_note_id': prompt.triggerVoiceNoteId,
      'prompt_text': prompt.promptText,
      'prompt_type': prompt.promptType.name,
      'shown_at': prompt.shownAt.toIso8601String(),
      'dismissed_at': prompt.dismissedAt?.toIso8601String(),
      'created_at': prompt.createdAt.toIso8601String(),
    });
  }

  @override
  Future<void> saveResponse(FollowUpResponse response) async {
    final db = await AppDatabase.open();
    await db.insert('follow_up_responses', {
      'id': response.id,
      'follow_up_prompt_id': response.followUpPromptId,
      'response_type': response.responseType.name,
      'text_content': response.textContent,
      'voice_note_id': response.voiceNoteId,
      'created_at': response.createdAt.toIso8601String(),
    });
  }
}
