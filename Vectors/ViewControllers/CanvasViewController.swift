import SnapKit
import SpriteKit
import RxSwift
import RxCocoa

final class CanvasViewController: UIViewController {
    private let canvasView = CanvasView()
    private let menuView = MenuView()
    private var scene: VectorsSKScene?

    private let viewModel = CanvasViewModel(vectorProvider: MockVectorProvider())
    private lazy var dataSource = makeDataSource()

    private let bag = DisposeBag()
    private let getAllVectors = PublishRelay<Void>()
    private let editVector = PublishRelay<VectorModel>()
    private let deleteVector = PublishRelay<VectorModel>()
    private let addVector = PublishRelay<VectorModel>()

    override func viewDidLoad() {
        addSubviews()
        setupConstraints()
        setupScene()
        menuView.theAddButtonCompletionHandler = { [weak self] in
            guard #available(iOS 16.0, *) else { return }
            let bottomSheetViewController = AddViewController()
            if let sheetController = bottomSheetViewController.presentationController
                as? UISheetPresentationController {
                sheetController.detents = [
                    .custom { _ in
                    guard let self else { return nil }
                    return self.view.bounds.height / 3 - self.view.safeAreaInsets.bottom
                } ]
                sheetController.prefersGrabberVisible = true
            }
            bottomSheetViewController.addVector = { vector in
                print(vector)
                self?.deleteVector.accept(vector)
            }
            self?.present(bottomSheetViewController, animated: true)
        }
        menuView.vectorsCollectionDelegate = self
        bindViewModel()
        getAllVectors.accept(())
    }

    private func bindViewModel() {
        let inputs = CanvasViewModel.Input(
            showAllVectors: getAllVectors.asObservable(),
            editVector: editVector.asObservable(),
            deleteVector: deleteVector.asObservable(),
            addVector: addVector.asObservable()
        )
        let outputs = viewModel.transform(input: inputs)
        outputs.showAllVectors
            .do { [weak self] model in
                self?.applySnapshot(model: model)
                self?.scene?.redrawVectors(model: model)
            }
            .drive()
            .disposed(by: bag)

        outputs.editVector
            .do { [weak self] model in
                self?.updateSnapshotWith(vector: model)
                self?.scene?.drawVector(start: model.start, end: model.end, id: model.id, color: model.color)
            }
            .drive()
            .disposed(by: bag)

        outputs.deleteVector
            .do { [weak self] model in
                self?.deleteSnapshotWith(vector: model)
                self?.scene?.deleteVector(id: model.id)
            }
            .drive()
            .disposed(by: bag)

        outputs.addVector
            .do { [weak self] model in
                self?.addSnapshotWith(vector: model)
                self?.scene?.drawVector(start: model.start, end: model.end, id: model.id, color: model.color)
            }
            .drive()
            .disposed(by: bag)
    }

    private func addSubviews() {
        view.addSubview(canvasView)
        view.addSubview(menuView)
    }

    private func setupConstraints() {
        canvasView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        menuView.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(view.layoutMarginsGuide)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
    }

    private func setupScene() {
        let scene = VectorsSKScene()
        scene.scaleMode = .aspectFill
        self.scene = scene
        canvasView.setupWith(scene: scene)
    }
}

extension CanvasViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, VectorModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, VectorModel>

    enum Section {
        case main
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: menuView.vectorsCollection
        ) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: VectorCollectionCell.identifier,
                for: indexPath) as? VectorCollectionCell
            cell?.prepareCell(start: model.start, end: model.end, color: model.color)
            return cell
        }
        return dataSource
    }

    func addSnapshotWith(vector: VectorModel, animatingDifferences: Bool = false) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([vector])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func updateSnapshotWith(vector: VectorModel, animatingDifferences: Bool = false) {
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([vector])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func deleteSnapshotWith(vector: VectorModel, animatingDifferences: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([vector])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func applySnapshot(model: [VectorModel], animatingDifferences: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(model, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension CanvasViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: menuView.frame.size.width,
            height: 100
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}
