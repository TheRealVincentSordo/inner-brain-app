import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/follow_up/follow_up_prompt.dart';
import '../shared/providers.dart';
import '../theme_graph/home_graph_screen.dart';

class FollowUpPromptScreen extends ConsumerStatefulWidget {
  const FollowUpPromptScreen({super.key, required this.prompt});

  final FollowUpPrompt prompt;

  @override
  ConsumerState<FollowUpPromptScreen> createState() => _FollowUpPromptScreenState();
}

class _FollowUpPromptScreenState extends ConsumerState<FollowUpPromptScreen> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Follow-Up Prompt')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.prompt.promptText),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Optional response',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeGraphScreen()),
                    (_) => false,
                  ),
                  child: const Text('Skip'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      await ref.read(submitResponseUseCaseProvider).submitText(
                            promptId: widget.prompt.id,
                            responseText: text,
                          );
                      await ref.read(updateThemeGraphUseCaseProvider)(text: text);
                    }
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeGraphScreen()),
                      (_) => false,
                    );
                  },
                  child: const Text('Save response'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Voice follow-up can be added by recording another note from Home (MVP shortcut).'),
          ],
        ),
      ),
    );
  }
}
