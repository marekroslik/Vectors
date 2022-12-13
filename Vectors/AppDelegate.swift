import UIKit
import Swinject

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let container: Container = {
        let provider = DIProvider()
        return provider.container
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = GameViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
