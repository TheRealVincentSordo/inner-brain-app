package com.example.inner_sphere

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val channelName = "inner_sphere/transcription"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                when (call.method) {
                    "transcribeAudio" -> {
                        // TODO(MVP-native): Integrate Android on-device transcription API.
                        // Expected args: filePath (String), locale (String)
                        // Return: List<String> transcript segments.
                        result.success(listOf<String>())
                    }
                    "isOnDeviceTranscriptionAvailable" -> {
                        // TODO(MVP-native): Check locale/device support.
                        result.success(false)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
