import UIKit

final class VectorModel {
    let id: String
    var start: CGPoint
    var end: CGPoint
    let color: UIColor

    init(
        id: String = UUID().uuidString,
        start: CGPoint,
        end: CGPoint
    ) {
        self.id = id
        self.start = start
        self.end = end
        self.color = UIColor.random()
    }
}

extension VectorModel {
    func whereIsTouchFor(
        point touchPoint: CGPoint,
        withTolerance tolerance: CGFloat = 0.3
    ) -> Touch {
        if end.distance(toPoint: touchPoint) <= tolerance { return .end }
        if start.distance(toPoint: touchPoint) <= tolerance { return .start }
        if touchPoint.distance(toLineSegment: (start, end)) <= tolerance { return .body }
        return .none
    }

    enum Touch {
        case start
        case end
        case body
        case none
    }
}

extension VectorModel: Hashable, Identifiable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: VectorModel, rhs: VectorModel) -> Bool {
        return lhs.id == rhs.id
    }
}
