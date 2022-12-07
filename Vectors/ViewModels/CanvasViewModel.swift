import RxSwift
import RxCocoa

final class CanvasViewModel: RXViewModelProtocol {
    struct Input {
        let showAllVectors: Observable<Void>
        let editVector: Observable<VectorModel>
    }

    struct Output {
        let showAllVectors: Driver<[VectorModel]>
        let editVector: Driver<VectorModel>
    }

    private let vectorProvider: VectorProviderProtocol

    init(vectorProvider: VectorProviderProtocol) {
        self.vectorProvider = vectorProvider
    }

    func transform(input: Input) -> Output {
        let showAllVectors = input.showAllVectors
            .flatMapLatest { [vectorProvider] in
                return Observable.just(vectorProvider.getAllVectors())
            }
            .asDriver(onErrorJustReturn: [VectorModel]())

        let editVector = input.editVector
            .do { [vectorProvider] model in
                vectorProvider.update(vector: model)
            }
            .asDriver(onErrorJustReturn: VectorModel(id: "1", start: CGPoint(x: 1, y: 1), end: CGPoint(x: 2, y: 2)))

        return Output(
            showAllVectors: showAllVectors,
            editVector: editVector
        )
    }
}
