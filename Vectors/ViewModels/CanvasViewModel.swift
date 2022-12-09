import RxSwift
import RxCocoa

final class CanvasViewModel: RXViewModelProtocol {
    struct Input {
        let showAllVectors: Observable<Void>
        let editVector: Observable<VectorModel>
        let deleteVector: Observable<VectorModel>
        let addVector: Observable<VectorModel>
    }

    struct Output {
        let showAllVectors: Driver<[VectorModel]>
        let editVector: Driver<VectorModel>
        let deleteVector: Driver<VectorModel>
        let addVector: Driver<VectorModel>
    }

    private let vectorProvider: VectorProviderProtocol

    init(vectorProvider: VectorProviderProtocol) {
        self.vectorProvider = vectorProvider
    }

    func transform(input: Input) -> Output {
        let showAllVectors = input.showAllVectors
            .flatMapLatest { [vectorProvider] _ -> Observable<[VectorModel]> in
                return Observable.just(vectorProvider.getAllVectors())
            }
            .asDriver(onErrorJustReturn: [VectorModel]())

        let editVector = input.editVector
            .do { [vectorProvider] model in
                vectorProvider.update(vector: model)
            }
            .asDriver(onErrorJustReturn: VectorModel(id: "1", start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 0)))

        let deleteVector = input.deleteVector
            .do { [vectorProvider] model in
                vectorProvider.delete(id: model.id)
            }
            .asDriver(onErrorJustReturn: VectorModel(id: "1", start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 0)))

        let addVector = input.deleteVector
            .do { [vectorProvider] model in
                vectorProvider.save(vector: model)
            }
            .asDriver(onErrorJustReturn: VectorModel(id: "1", start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 0)))

        return Output(
            showAllVectors: showAllVectors,
            editVector: editVector,
            deleteVector: deleteVector,
            addVector: addVector
        )
    }
}
