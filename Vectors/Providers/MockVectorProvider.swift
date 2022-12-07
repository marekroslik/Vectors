import Foundation

final class MockVectorProvider: VectorProviderProtocol {

    private var mockVectors = [
        VectorModel(id: "1", start: CGPoint(x: 0, y: 0), end: CGPoint(x: 1, y: 1)),
        VectorModel(id: "2", start: CGPoint(x: 2, y: 2), end: CGPoint(x: 3, y: 3)),
        VectorModel(id: "3", start: CGPoint(x: 4, y: 4), end: CGPoint(x: 5, y: 5)),
        VectorModel(id: "4", start: CGPoint(x: 6, y: 6), end: CGPoint(x: 7, y: 7)),
        VectorModel(id: "5", start: CGPoint(x: 8, y: 8), end: CGPoint(x: 9, y: 9))
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
