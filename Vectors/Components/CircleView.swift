import UIKit

class CircleView: UIView {
    override var collisionBoundsType:
    UIDynamicItemCollisionBoundsType { return .ellipse }
    override func layoutSubviews() {
        super.layoutSubviews()
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.path = circularPath(center: center).cgPath
        layer.addSublayer(shapeLayer)
    }
    private func circularPath(center: CGPoint = .zero) -> UIBezierPath {
        let radius = min(bounds.width, bounds.height) / 2
        return UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true
        )
    }
}
