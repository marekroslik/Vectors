import Foundation

final class VectorModel {
    let id: Int
    let start: CGPoint
    let end: CGPoint

    init(
        id: Int,
        start: CGPoint,
        end: CGPoint
    ) {
        self.id = id
        self.start = start
        self.end = end
    }
}

extension VectorModel: Hashable {
    static func == (lhs: VectorModel, rhs: VectorModel) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
