import Foundation
import Swinject

final class DIProvider {
    let container = Container()

    init() {
        self.setup()
    }

    private func setup() {
        container.register(VectorProviderProtocol.self, name: "Realm") { _ in
            return RealmVectorProvider()
        }

        container.register(VectorProviderProtocol.self, name: "Mock") { _ in
            return MockVectorProvider()
        }

        container.register(CanvasViewModel.self, name: "Realm") { resolver in
            let provider = resolver.resolve(VectorProviderProtocol.self, name: "Realm")
            let canvas = CanvasViewModel(vectorProvider: provider!)
            return canvas
        }

        container.register(CanvasViewModel.self, name: "Mock") { resolver in
            let provider = resolver.resolve(VectorProviderProtocol.self, name: "Mock")
            let canvas = CanvasViewModel(vectorProvider: provider!)
            return canvas
        }
    }
}
