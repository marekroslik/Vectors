import Foundation

final class MockVectorProvider: VectorProviderProtocol {

    private var mockVectors = [
        VectorModel(start: CGPoint(x: 1, y: 2), end: CGPoint(x: 2, y: 1)),
        VectorModel(start: CGPoint(x: 1, y: 3), end: CGPoint(x: 3, y: 1)),
        VectorModel(start: CGPoint(x: 1, y: 4), end: CGPoint(x: 4, y: 1)),
        VectorModel(start: CGPoint(x: -2, y: 1), end: CGPoint(x: -1, y: 2)),
        VectorModel(start: CGPoint(x: -3, y: 1), end: CGPoint(x: -1, y: 3)),
        VectorModel(start: CGPoint(x: -4, y: 1), end: CGPoint(x: -1, y: 4)),
        VectorModel(start: CGPoint(x: 2, y: -1), end: CGPoint(x: 1, y: -2)),
        VectorModel(start: CGPoint(x: 3, y: -1), end: CGPoint(x: 1, y: -3)),
        VectorModel(start: CGPoint(x: 4, y: -1), end: CGPoint(x: 1, y: -4)),
        VectorModel(start: CGPoint(x: -1, y: -2), end: CGPoint(x: -2, y: -1)),
        VectorModel(start: CGPoint(x: -1, y: -3), end: CGPoint(x: -3, y: -1)),
        VectorModel(start: CGPoint(x: -1, y: -4), end: CGPoint(x: -4, y: -1))
    ]

    func getAllVectors() -> [VectorModel] {
        return mockVectors
    }

    func save(vector: VectorModel) {
        mockVectors.append(vector)
    }

    func delete(id: String) {
        if let index = mockVectors.firstIndex(where: { $0.id == id }) {
            mockVectors.remove(at: index)
        }
    }

    func update(vector: VectorModel) {
        if let index = mockVectors.firstIndex(where: {$0.id == vector.id }) {
            mockVectors[index] = vector
        }
    }
}
