import RxSwift
import RxCocoa

final class CanvasViewModel: RXViewModelProtocol {
    typealias Touch = (CGPoint, UIGestureRecognizer.State)

    struct Input {
        let showAllVectors: Observable<Void>
        let deleteVector: Observable<VectorModel>
        let addVector: Observable<VectorModel>
        let gestureRecognizer: Observable<Touch>
    }

    struct Output {
        let showAllVectors: Driver<[VectorModel]>
        let editVector: Driver<VectorModel>
        let deleteVector: Driver<VectorModel>
        let addVector: Driver<VectorModel>
    }

    private let vectorProvider: VectorProviderProtocol

    private var movableVector: VectorModel?
    private var touchType: VectorModel.Touch?
    private var firstGestureCoordinates: CGPoint?

    init(vectorProvider: VectorProviderProtocol) {
        self.vectorProvider = vectorProvider
    }

    // swiftlint:disable all
    func transform(input: Input) -> Output {
        let editVector = input.gestureRecognizer
            .flatMap { [weak self] point, state -> Observable<VectorModel> in
                switch state {
                case .began:
                    self?.firstGestureCoordinates = point
                    guard
                        let vector = self?.vectorProvider.getAllVectors().first(where: { vector in
                            vector.whereIsTouchFor(point: point) != .none
                        }) else { return Observable.never() }
                    self?.movableVector = vector
                    self?.touchType = vector.whereIsTouchFor(point: point)
                    return Observable.never()
                case .changed:
                    switch self?.touchType {
                    case .start:
                        guard var newVector = self?.movableVector else { return Observable.never() }
                        newVector.start = point
                        self?.movableVector?.start = point
                        return Observable.just(newVector)
                    case .end:
                        guard var newVector = self?.movableVector else { return Observable.never() }
                        newVector.end = point
                        self?.movableVector?.end = point
                        return Observable.just(newVector)
                    case .body:
                        guard
                            var newVector = self?.movableVector,
                            let firstX = self?.firstGestureCoordinates?.x,
                            let firstY = self?.firstGestureCoordinates?.y
                        else {
                            return Observable.never()
                        }
                        let deltaX = point.x - firstX
                        let deltaY = point.y - firstY
                        newVector.start.x += deltaX
                        newVector.start.y += deltaY
                        newVector.end.x += deltaX
                        newVector.end.y += deltaY
                        self?.movableVector?.start = newVector.start
                        self?.movableVector?.end = newVector.end
                        self?.firstGestureCoordinates = point
                        return Observable.just(newVector)
                    default: return Observable.never()
                    }
                case .ended:
                    guard let newVector = self?.movableVector else { return Observable.never() }
                    self?.vectorProvider.update(vector: newVector)
                    self?.firstGestureCoordinates = nil
                    self?.movableVector = nil
                    self?.touchType = nil
                    return Observable.just(newVector)
                default:
                    self?.movableVector = nil
                    self?.touchType = nil
                    self?.firstGestureCoordinates = nil
                    return Observable.never()
                }
            }
            .asDriverIgnoringErrors()

        let showAllVectors = input.showAllVectors
            .flatMapLatest { [vectorProvider] _ -> Observable<[VectorModel]> in
                return Observable.just(vectorProvider.getAllVectors())
            }
            .asDriverIgnoringErrors()

        let deleteVector = input.deleteVector
            .do { [vectorProvider] model in
                vectorProvider.delete(id: model.id)
            }
            .asDriverIgnoringErrors()

        let addVector = input.addVector
            .do { [vectorProvider] model in
                vectorProvider.save(vector: model)
            }
            .asDriverIgnoringErrors()

        return Output(
            showAllVectors: showAllVectors,
            editVector: editVector,
            deleteVector: deleteVector,
            addVector: addVector
        )
    }
}
