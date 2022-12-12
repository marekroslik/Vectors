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
        vectors.append(vector)
    }

    func delete(id: String) {
        if var realmVector = realm?.objects(RealmVectorModel.self).first(where: {$0.id == id }) {
            try? realm?.write {
                realm?.delete(realmVector)
            }
        }
        if let index = vectors.firstIndex(where: { $0.id == id }) {
            vectors.remove(at: index)
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
        if let index = vectors.firstIndex(where: {$0.id == vector.id }) {
            vectors[index] = vector
        }
    }
}
