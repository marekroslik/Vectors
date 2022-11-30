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
