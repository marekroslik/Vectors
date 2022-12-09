import UIKit

final class BaseTextField: UITextField {

    init(withTitle title: String) {
        super.init(frame: .zero)
        backgroundColor = .black
        textColor = .white
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        textAlignment = .center
        keyboardType = UIKeyboardType.decimalPad
        placeholder = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
