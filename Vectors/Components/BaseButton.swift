import UIKit

final class BaseButton: UIButton {

    init(withTitle title: String) {
        super.init(frame: .zero)
        setTitle(title.uppercased(), for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = UIColor.black
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
