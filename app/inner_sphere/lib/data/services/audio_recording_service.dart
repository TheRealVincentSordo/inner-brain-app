import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecordingService {
  final AudioRecorder _recorder = AudioRecorder();

  Future<bool> hasPermission() => _recorder.hasPermission();

  Future<String> start() async {
    final dir = await getApplicationDocumentsDirectory();
    final audioDir = Directory(p.join(dir.path, 'voice_notes'));
    await audioDir.create(recursive: true);
    final output = p.join(audioDir.path, 'note_${DateTime.now().millisecondsSinceEpoch}.m4a');
    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: output);
    return output;
  }

  Future<void> pause() => _recorder.pause();
  Future<void> resume() => _recorder.resume();
  Future<String?> stop() => _recorder.stop();
}
