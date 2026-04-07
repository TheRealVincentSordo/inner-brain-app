import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let channelName = "inner_sphere/transcription"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "transcribeAudio":
        // TODO(MVP-native): Integrate Speech framework for on-device transcription.
        // Args: filePath (String), locale (String)
        // Return: [String] transcript segments.
        result([String]())
      case "isOnDeviceTranscriptionAvailable":
        // TODO(MVP-native): Return locale/device availability.
        result(false)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
