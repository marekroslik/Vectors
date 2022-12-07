import SnapKit

final class MenuView: UIView {

    var theAddButtonCompletionHandler: (() -> Void)?

    var vectorsCollectionDelegate: UICollectionViewDelegate? {
        didSet {
            vectorsCollection.delegate = vectorsCollectionDelegate
        }
    }

    let vectorsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(
            VectorCollectionCell.self,
            forCellWithReuseIdentifier: VectorCollectionCell.identifier
        )
        collectionView.backgroundColor = UIColor.black
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.white.cgColor
        return collectionView
    }()

    private let addButton = BaseButton(withTitle: "Add")
    private let hideButton = BaseButton(withTitle: "Hide")
    private let menuButton = BaseButton(withTitle: "Menu")

    private func isMenuShow(_ isShow: Bool) {
        vectorsCollection.isHidden = !isShow
        addButton.isHidden = !isShow
        hideButton.isHidden = !isShow
        menuButton.isHidden = isShow
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addSubviews()
        addConstraints()
        isMenuShow(false)
        hideButton.addTarget(self, action: #selector(hideMenu), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTarget), for: .touchUpInside)
    }

    @objc private func addButtonTarget() {
        self.theAddButtonCompletionHandler?()
    }

    @objc private func showMenu() {
        isMenuShow(true)
    }

    @objc private func hideMenu() {
        isMenuShow(false)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addSubviews() {
        addSubview(vectorsCollection)
        addSubview(addButton)
        addSubview(hideButton)
        addSubview(menuButton)
    }

    private func addConstraints() {
        vectorsCollection.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(addButton.snp.top).offset(-10)
        }

        menuButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(50)
        }

        hideButton.snp.makeConstraints { make in
            make.edges.equalTo(menuButton)
        }

        addButton.snp.makeConstraints { make in
            make.size.equalTo(hideButton)
            make.bottom.equalTo(hideButton.snp.top).offset(-10)
        }
    }
}

extension MenuView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
