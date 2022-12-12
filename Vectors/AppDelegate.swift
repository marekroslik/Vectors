import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let dependencyProvider = DIProvider()
        let viewModel = dependencyProvider.container.resolve(CanvasViewModel.self, name: "Realm")
        window?.rootViewController = CanvasViewController(viewModel: viewModel!)
        window?.makeKeyAndVisible()
        return true
    }
}
