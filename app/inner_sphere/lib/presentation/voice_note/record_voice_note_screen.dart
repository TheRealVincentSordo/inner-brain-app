import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/voice_note/voice_note.dart';
import '../shared/providers.dart';
import '../transcript/transcript_review_screen.dart';

class RecordVoiceNoteScreen extends ConsumerStatefulWidget {
  const RecordVoiceNoteScreen({super.key});

  @override
  ConsumerState<RecordVoiceNoteScreen> createState() => _RecordVoiceNoteScreenState();
}

class _RecordVoiceNoteScreenState extends ConsumerState<RecordVoiceNoteScreen> {
  DateTime? _startedAt;
  String _status = 'Ready to capture a reflection.';
  bool _recording = false;

  @override
  Widget build(BuildContext context) {
    final useCase = ref.read(recordVoiceNoteUseCaseProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Record Voice Note')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_status, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: !_recording
                      ? () async {
                          final permitted = await useCase.hasPermission();
                          if (!permitted) {
                            setState(() => _status = 'Microphone permission is needed to continue.');
                            return;
                          }
                          _startedAt = DateTime.now();
                          await useCase.start();
                          setState(() {
                            _recording = true;
                            _status = 'Recording… speak naturally.';
                          });
                        }
                      : null,
                  icon: const Icon(Icons.fiber_manual_record),
                  label: const Text('Start'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _recording
                      ? () async {
                          final note = await useCase.stopAndSave(
                            startedAt: _startedAt ?? DateTime.now(),
                            source: VoiceNoteSource.primaryNote,
                          );
                          if (!mounted || note == null) return;
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => TranscriptReviewScreen(note: note)),
                          );
                        }
                      : null,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
