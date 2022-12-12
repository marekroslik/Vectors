import UIKit
import Swinject

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let container = DIProvider().container

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = container.resolve(CanvasViewController.self)
        window?.makeKeyAndVisible()
        return true
    }
}
