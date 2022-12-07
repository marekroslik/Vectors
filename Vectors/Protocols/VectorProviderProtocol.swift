protocol VectorProviderProtocol {
    func getAllVectors() -> [VectorModel]
    func save(vector: VectorModel)
    func delete(id: String)
    func update(vector: VectorModel)
}
