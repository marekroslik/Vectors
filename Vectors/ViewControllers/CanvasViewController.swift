import SnapKit
import SpriteKit
import RxSwift
import RxCocoa

final class CanvasViewController: UIViewController {
    private let canvasView = CanvasView()
    private let menuView = MenuView()
    private var scene: VectorsSKScene?

    private let viewModel = CanvasViewModel(vectorProvider: RealmVectorProvider())
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
        setupMenu()
        bindViewModel()
        getAllVectors.accept(())
    }

    private func bindViewModel() {
        let inputs = CanvasViewModel.Input(
            showAllVectors: getAllVectors.asObservable(),
            deleteVector: deleteVector.asObservable(),
            addVector: addVector.asObservable(),
            gestureRecognizer: scene!.panGestureObserver()
        )

        let outputs = viewModel.transform(input: inputs)

        outputs.showAllVectors
            .do { [weak self] model in
                self?.applySnapshot(model: model)
                for vector in model {
                    self?.scene?.draw(vector: vector)
                }
            }
            .drive()
            .disposed(by: bag)

        outputs.editVector
            .do { [weak self] model in
                self?.updateSnapshotWith(vector: model)
                self?.scene?.draw(vector: model)
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
                self?.scene?.draw(vector: model)
            }
            .drive()
            .disposed(by: bag)

        outputs.moveCameraWithDelta
            .do { [weak self] point in
                self?.scene?.moveTheCamera(xDelta: point.x, yDelta: point.y)
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

    private func setupMenu() {
        menuView.vectorsCollection.delegate = self
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
                self?.addVector.accept(vector)
            }
            self?.present(bottomSheetViewController, animated: true)
        }
    }
}

extension CanvasViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, VectorModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, VectorModel>

    enum Section {
        case main
    }

    private func makeDataSource() -> DataSource {
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

    private func addSnapshotWith(vector: VectorModel, animatingDifferences: Bool = false) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([vector])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func updateSnapshotWith(vector: VectorModel, animatingDifferences: Bool = false) {
        var snapshot = dataSource.snapshot()
        guard
            let vectorSnapshot = snapshot.itemIdentifiers.first(where: { $0.id == vector.id })
        else { return }
        vectorSnapshot.start = vector.start
        vectorSnapshot.end = vector.end
        snapshot.reloadItems([vector])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func deleteSnapshotWith(vector: VectorModel, animatingDifferences: Bool = true) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([vector])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func applySnapshot(model: [VectorModel], animatingDifferences: Bool = false) {
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

    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemsAt indexPaths: [IndexPath],
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { [weak self] _ in
            let open = UIAction(
                title: "Delete",
                image: UIImage(systemName: "trash"),
                attributes: .destructive,
                state: .off
            ) { _ in
                guard
                    let index = indexPaths.first,
                    let vector = self?.dataSource.itemIdentifier(for: index)
                else {
                    return
                }
                self?.deleteVector.accept(vector)
            }
            return UIMenu(title: "Action", options: UIMenu.Options.displayInline, children: [open])
        }
        return config
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let vector = self.dataSource.itemIdentifier(for: indexPath)
        else {
            return
        }
        self.scene?.showVector(id: vector.id)
    }
}
