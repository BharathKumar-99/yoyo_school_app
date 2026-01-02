import UIKit
import Flutter
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        // 1. Set Notification Delegate to handle banners while app is open
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        // 2. Register for remote notifications (triggers APNs token request)
        application.registerForRemoteNotifications()
        
        // 3. Register Flutter Plugins
        GeneratedPluginRegistrant.register(with: self)
        
        // 4. Minimize Channel Logic (Reused from your previous app)
        guard let controller = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        let channel = FlutterMethodChannel(name: "app/minimize", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { (call, result) in
            if call.method == "minimize" {
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                result(nil)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}