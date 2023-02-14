import UIKit
import Flutter
import ReplayKit


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        var controller = window.rootViewController as? FlutterViewController
        var screensharingIOSChannel = FlutterMethodChannel(
            name: "example_screensharing_ios",
            binaryMessenger: controller as! FlutterBinaryMessenger)
        
        screensharingIOSChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if #available(iOS 12.0, *) {
                DispatchQueue.main.async(execute: {
                  let systemBroadcastPicker = RPSystemBroadcastPickerView(
                    frame: CGRect(x: 50, y: 200, width: 60, height: 60))
                  systemBroadcastPicker.showsMicrophoneButton = true
                  systemBroadcastPicker.autoresizingMask = [.flexibleBottomMargin, .flexibleRightMargin]
                  if let url = Bundle.main.url(forResource: "Example_ScreenSharing_Extension", withExtension: "appex", subdirectory: "PlugIns"),
                    let bundle = Bundle(url: url) {
                      systemBroadcastPicker.preferredExtension = bundle.bundleIdentifier
                  }
                  controller?.view.addSubview(systemBroadcastPicker)
                })
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
