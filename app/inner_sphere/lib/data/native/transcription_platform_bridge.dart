import 'package:flutter/services.dart';

class TranscriptionPlatformBridge {
  static const _channel = MethodChannel('inner_sphere/transcription');

  Future<List<String>> transcribeAudio(String filePath, String locale) async {
    final result = await _channel.invokeMethod<List<dynamic>>(
      'transcribeAudio',
      {'filePath': filePath, 'locale': locale},
    );
    return (result ?? const []).map((e) => e.toString()).toList();
  }

  Future<bool> isOnDeviceTranscriptionAvailable(String locale) async {
    final result = await _channel.invokeMethod<bool>(
      'isOnDeviceTranscriptionAvailable',
      {'locale': locale},
    );
    return result ?? false;
  }
}
