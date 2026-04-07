import 'follow_up_prompt.dart';
import 'follow_up_response.dart';

abstract class FollowUpRepository {
  Future<void> savePrompt(FollowUpPrompt prompt);
  Future<void> saveResponse(FollowUpResponse response);
  Future<FollowUpPrompt?> latestPrompt();
}
