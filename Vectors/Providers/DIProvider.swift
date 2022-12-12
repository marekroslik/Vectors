import Foundation
import Swinject

final class DIProvider {
    let container = Container()

    init() {
        self.setup()
    }

    private func setup() {
        container.register(VectorProviderProtocol.self) { _ in
            return RealmVectorProvider()
        }

        container.register(VectorProviderProtocol.self, name: "Mock") { _ in
            return MockVectorProvider()
        }

        container.register(CanvasViewModel.self) { resolver in
            let provider = resolver.resolve(VectorProviderProtocol.self)
            let canvas = CanvasViewModel(vectorProvider: provider!)
            return canvas
        }

        container.register(CanvasViewModel.self, name: "Mock") { resolver in
            let provider = resolver.resolve(VectorProviderProtocol.self, name: "Mock")
            let canvas = CanvasViewModel(vectorProvider: provider!)
            return canvas
        }

        container.register(CanvasViewController.self) { resolver in
            let viewModel = resolver.resolve(CanvasViewModel.self)
            let viewController = CanvasViewController(viewModel: viewModel!)
            return viewController
        }

        container.register(CanvasViewController.self, name: "Mock") { resolver in
            let viewModel = resolver.resolve(CanvasViewModel.self, name: "Mock")
            let viewController = CanvasViewController(viewModel: viewModel!)
            return viewController
        }
    }
}
