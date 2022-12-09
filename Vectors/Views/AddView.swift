import SnapKit

final class AddView: UIView {
    typealias Vector = (start: CGPoint, end: CGPoint)

    var acceptButtonCompletionHandler: ((Vector) -> Void)?

    private let x1Coordinate = BaseTextField(withTitle: "X₁")

    private let y1Coordinate = BaseTextField(withTitle: "Y₁")

    private let x2Coordinate = BaseTextField(withTitle: "X₂")

    private let y2Coordinate = BaseTextField(withTitle: "Y₂")

    private let acceptButton = BaseButton(withTitle: "Add")

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addSubviews()
        addConstraints()
        acceptButton.addTarget(self, action: #selector(acceptButtonTarget), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func acceptButtonTarget() {
        guard
            let x1text = x1Coordinate.text,
            let x1Value = Double(x1text),
            let x2text = x2Coordinate.text,
            let x2Value = Double(x2text),
            let y1text = y1Coordinate.text,
            let y1Value = Double(y1text),
            let y2text = y2Coordinate.text,
            let y2Value = Double(y2text)
        else {
            acceptButton.playDenyAnimation()
            return
        }
        let start = CGPoint(
            x: x1Value,
            y: y1Value
        )
        let end = CGPoint(
            x: x2Value,
            y: y2Value
        )
        clearTextFields()
        self.acceptButtonCompletionHandler?((start: start, end: end))
    }

    private func clearTextFields() {
        x1Coordinate.text = nil
        y1Coordinate.text = nil
        x2Coordinate.text = nil
        y2Coordinate.text = nil
        x1Coordinate.becomeFirstResponder()
    }

    private func addSubviews() {
        addSubview(x1Coordinate)
        addSubview(y1Coordinate)
        addSubview(x2Coordinate)
        addSubview(y2Coordinate)
        addSubview(acceptButton)
    }

    private func addConstraints() {
        x1Coordinate.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview()
            make.height.equalTo(62)
            make.width.equalToSuperview().dividedBy(2).offset(-5)
        }

        y1Coordinate.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview()
            make.size.equalTo(x1Coordinate)
        }

        x2Coordinate.snp.makeConstraints { make in
            make.top.equalTo(x1Coordinate.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.size.equalTo(x1Coordinate)
        }

        y2Coordinate.snp.makeConstraints { make in
            make.top.equalTo(x1Coordinate.snp.bottom).offset(10)
            make.right.equalToSuperview()
            make.size.equalTo(x1Coordinate)
        }

        acceptButton.snp.makeConstraints { make in
            make.top.equalTo(y2Coordinate.snp.bottom).offset(10)
            make.height.equalTo(x1Coordinate)
            make.left.right.equalToSuperview()
        }
    }
}
