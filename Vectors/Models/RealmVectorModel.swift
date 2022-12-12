import Foundation
import RealmSwift

final class RealmVectorModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var startX = 0.0
    @objc dynamic var startY = 0.0
    @objc dynamic var endX = 0.0
    @objc dynamic var endY = 0.0

    static func create(withModel model: VectorModel) -> RealmVectorModel {
        let vector = RealmVectorModel()
        vector.id = model.id
        vector.startX = model.start.x
        vector.startY = model.start.y
        vector.endX = model.end.x
        vector.endY = model.end.y
        return vector
    }

    func convert() -> VectorModel {
        let start = CGPoint(
            x: self.startX,
            y: self.startY
        )
        let end = CGPoint(
            x: self.endX,
            y: self.endY
        )
        let vector = VectorModel(
            id: self.id,
            start: start,
            end: end
        )
        return vector
    }
}
