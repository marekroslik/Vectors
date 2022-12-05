import Foundation

struct VectorModel {
    let id: String
    var start: CGPoint
    var end: CGPoint

    init(
        id: String,
        start: CGPoint,
        end: CGPoint
    ) {
        self.id = id
        self.start = start
        self.end = end
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
