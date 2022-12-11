import UIKit

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            hue: .random(in: 0...1),
            saturation: .random(in: 0.5...1),
            brightness: .random(in: 0.5...1),
            alpha: 1.0
        )
    }
}
