import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/voice_note/voice_note.dart';
import '../follow_up/follow_up_prompt_screen.dart';
import '../shared/providers.dart';

class ThemeReviewScreen extends ConsumerStatefulWidget {
  const ThemeReviewScreen({
    super.key,
    required this.note,
    required this.transcriptText,
    this.primarySegmentId,
  });

  final VoiceNote note;
  final String transcriptText;
  final String? primarySegmentId;

  @override
  ConsumerState<ThemeReviewScreen> createState() => _ThemeReviewScreenState();
}

class _ThemeReviewScreenState extends ConsumerState<ThemeReviewScreen> {
  final Set<String> _selected = {};
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final extract = ref.read(updateThemeGraphUseCaseProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Review')),
      body: FutureBuilder<List<String>>(
        future: extract(
          text: widget.transcriptText,
          voiceNoteId: widget.note.id,
          transcriptSegmentId: widget.primarySegmentId,
        ),
        builder: (_, snapshot) {
          final themes = snapshot.data ?? const [];
          if (!_initialized && themes.isNotEmpty) {
            _selected.addAll(themes);
            _initialized = true;
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select the themes that feel true for this note.'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: themes
                      .map(
                        (t) => FilterChip(
                          selected: _selected.contains(t),
                          onSelected: (v) => setState(() => v ? _selected.add(t) : _selected.remove(t)),
                          label: Text(t),
                        ),
                      )
                      .toList(),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final prompt = await ref.read(generatePromptUseCaseProvider)(widget.note.id, _selected.toList());
                    if (!context.mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => FollowUpPromptScreen(prompt: prompt)),
                    );
                  },
                  child: const Text('Update graph'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
