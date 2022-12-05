// swiftlint:disable all
import Foundation

extension CGPoint {
    func convertTo(multiplyScalar: CGFloat) -> CGPoint {
        let result = CGPoint(
            x: self.x * multiplyScalar,
            y: self.y * multiplyScalar
        )
        return result
    }

    func convertFrom(multiplyScalar: CGFloat) -> CGPoint {
        let result = CGPoint(
            x: self.x / multiplyScalar,
            y: self.y / multiplyScalar
        )
        return result
    }

    func distance(toPoint point: CGPoint) -> CGFloat {
        let result = sqrt((self.x - point.x) * (self.x - point.x) + (self.y - point.y) * (self.y - point.y))
        return result
    }

    typealias LineSegment = (start: CGPoint, end: CGPoint)

    //https://stackoverflow.com/questions/28505344/shortest-distance-from-cgpoint-to-segment
    func distance(toLineSegment lineSegment: LineSegment) -> CGFloat {
        let pv_dx = self.x - lineSegment.start.x
        let pv_dy = self.y - lineSegment.start.y
        let wv_dx = lineSegment.end.x - lineSegment.start.x
        let wv_dy = lineSegment.end.y - lineSegment.start.y

        let dot = pv_dx * wv_dx + pv_dy * wv_dy
        let len_sq = wv_dx * wv_dx + wv_dy * wv_dy
        let param = dot / len_sq

        var int_x, int_y: CGFloat

        if param < 0 || (lineSegment.start.x == lineSegment.end.x && lineSegment.start.y == lineSegment.end.y) {
            int_x = lineSegment.start.x
            int_y = lineSegment.start.y
        } else if param > 1 {
            int_x = lineSegment.end.x
            int_y = lineSegment.end.y
        } else {
            int_x = lineSegment.start.x + param * wv_dx
            int_y = lineSegment.start.y + param * wv_dy
        }
        let dx = self.x - int_x
        let dy = self.y - int_y

        return sqrt(dx * dx + dy * dy)
    }
}
