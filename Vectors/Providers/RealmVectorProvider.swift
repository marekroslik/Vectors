import RealmSwift

final class RealmVectorProvider: VectorProviderProtocol {
    let realm = try? Realm()
    private var vectors: [VectorModel] = []

    func getAllVectors() -> [VectorModel] {
        if vectors.isEmpty {
            let vectorsBD = realm?.objects(RealmVectorModel.self)
            for vector in vectorsBD! {
                self.vectors.append(vector.convert())
            }
        }
        return vectors
    }

    func save(vector: VectorModel) {
        try? realm?.write {
            realm?.add(RealmVectorModel.create(withModel: vector))
        }
    }

    func delete(id: String) {
        if var realmVector = realm?.objects(RealmVectorModel.self).first {
            try? realm?.write {
                realm?.delete(realmVector)
            }
        }
    }

    func update(vector: VectorModel) {
        if var realmVector = realm?.objects(RealmVectorModel.self).first(where: {$0.id == vector.id }) {
            try? realm?.write {
                realmVector.startX = vector.start.x
                realmVector.startY = vector.start.y
                realmVector.endX = vector.end.x
                realmVector.endY = vector.end.y
            }
            print(realmVector)
        }
    }
}
