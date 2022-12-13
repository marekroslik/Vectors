import SnapKit

final class GameView: UIView {
    let gridView: UIView = {
        let view = UIView()
        return view
    }()

    let endArea1: UILabel = {
        let label = UILabel()
        label.text = "X5"
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        return label
    }()

    let endArea2: UILabel = {
        let label = UILabel()
        label.text = "X2"
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.05)
        return label
    }()

    let endArea3: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.01)
        return label
    }()

    let endArea4: UILabel = {
        let label = UILabel()
        label.text = "X2"
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.05)
        return label
    }()

    let endArea5: UILabel = {
        let label = UILabel()
        label.text = "X5"
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        self.addSubview(gridView)
        self.addSubview(endArea1)
        self.addSubview(endArea2)
        self.addSubview(endArea3)
        self.addSubview(endArea4)
        self.addSubview(endArea5)
    }

    private func addConstraints() {
        gridView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(endArea1.snp.top)
        }
        endArea1.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalToSuperview()
            make.right.equalTo(endArea2.snp.left)
            make.width.equalTo(endArea3).dividedBy(2)
        }
        endArea2.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalTo(endArea1.snp.right)
            make.right.equalTo(endArea3.snp.left)
            make.width.equalTo(endArea3).dividedBy(2)
        }
        endArea3.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalTo(endArea2.snp.right)
            make.right.equalTo(endArea4.snp.left)
        }
        endArea4.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalTo(endArea3.snp.right)
            make.right.equalTo(endArea5.snp.left)
            make.width.equalTo(endArea3).dividedBy(2)
        }
        endArea5.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
            make.left.equalTo(endArea4.snp.right)
            make.right.equalToSuperview()
            make.width.equalTo(endArea3).dividedBy(2)
        }
    }
}
