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

    override func viewDidLoad() {
        addSubviews()
        setupConstraints()
        setupScene()
        menuView.theAddButtonCompletionHandler = {
            print("ADD PRESS")
        }
        menuView.vectorsCollectionDelegate = self
        bindViewModel()
        getAllVectors.accept(())
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { [weak self] _ in
            self?.editVector.accept(VectorModel(id: "1", start: CGPoint(x: 10, y: 10), end: CGPoint(x: 1, y: 1)))
        }
    }

    private func bindViewModel() {
        let inputs = CanvasViewModel.Input(
            showAllVectors: getAllVectors.asObservable(),
            editVector: editVector.asObservable()
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
                self?.updateSnapshot(vector: model)
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

    func updateSnapshot(vector: VectorModel) {
        var newSnapshot = dataSource.snapshot()
        newSnapshot.reloadItems([vector])
        dataSource.apply(newSnapshot, animatingDifferences: true)
    }

    func applySnapshot(model: [VectorModel], animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(model)
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
