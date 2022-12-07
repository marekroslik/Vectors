import UIKit

class VectorModel {
    let id: String
    var start: CGPoint
    var end: CGPoint
    let color: UIColor

    init(
        id: String,
        start: CGPoint,
        end: CGPoint
    ) {
        self.id = id
        self.start = start
        self.end = end
        self.color = UIColor(
            red: .random(in: 0.3...1),
            green: .random(in: 0.3...1),
            blue: .random(in: 0.3...1),
            alpha: 1.0
        )
    }
}

extension VectorModel {
    func whereIsTouchFor(
        point touchPoint: CGPoint,
        withTolerance tolerance: CGFloat = 0.2
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

extension VectorModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: VectorModel, rhs: VectorModel) -> Bool {
        return lhs.id == rhs.id
    }
}
