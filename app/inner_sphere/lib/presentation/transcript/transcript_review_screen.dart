import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/transcript/transcript_segment.dart';
import '../../domain/voice_note/voice_note.dart';
import '../shared/providers.dart';
import '../theme_graph/theme_review_screen.dart';

class TranscriptReviewScreen extends ConsumerStatefulWidget {
  const TranscriptReviewScreen({super.key, required this.note});

  final VoiceNote note;

  @override
  ConsumerState<TranscriptReviewScreen> createState() => _TranscriptReviewScreenState();
}

class _TranscriptReviewScreenState extends ConsumerState<TranscriptReviewScreen> {
  bool _loading = true;
  String _error = '';
  List<TranscriptSegment> _segments = const [];

  @override
  void initState() {
    super.initState();
    _runTranscription();
  }

  Future<void> _runTranscription() async {
    try {
      final useCase = ref.read(transcribeVoiceUseCaseProvider);
      final segments = await useCase.call(widget.note.id, widget.note.audioFilePath, 'en-US');
      if (mounted) {
        setState(() {
          _segments = segments;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Transcription unavailable on this device right now. You can retry or continue.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transcript Review')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (_error.isNotEmpty) Text(_error),
            if (_segments.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _segments.length,
                  itemBuilder: (_, i) => ListTile(
                    title: Text(_segments[i].text),
                    subtitle: Text('Segment ${i + 1}'),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                final text = _segments.map((s) => s.text).join(' ');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => ThemeReviewScreen(
                      note: widget.note,
                      transcriptText: text,
                      primarySegmentId: _segments.isEmpty ? null : _segments.first.id,
                    ),
                  ),
                );
              },
              child: const Text('Continue to themes'),
            ),
          ],
        ),
      ),
    );
  }
}
