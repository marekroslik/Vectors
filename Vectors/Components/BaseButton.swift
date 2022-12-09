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

    func playDenyAnimation() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true

        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)

        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)

        shake.fromValue = fromValue
        shake.toValue = toValue

        layer.add(shake, forKey: "position")
    }
}
