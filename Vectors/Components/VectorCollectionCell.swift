import UIKit
import SnapKit

final class VectorCollectionCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    private let startCoordinate: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.textAlignment = .center
        return label
    }()

    private let endCoordinate: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.textAlignment = .center
        return label
    }()

    func prepareCell(start: CGPoint, end: CGPoint, color: UIColor) {
        startCoordinate.text = "(X₁ = \(start.x), Y₁ = \(start.y))"
        endCoordinate.text = "(X₂ = \(end.x), Y₂ = \(end.y))"
        self.backgroundColor = color
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addSubviews() {
        addSubview(startCoordinate)
        addSubview(endCoordinate)
    }

    private func addConstraints() {
        startCoordinate.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.bottom.equalTo(endCoordinate.snp.top)
            make.height.equalTo(endCoordinate)
            make.width.equalToSuperview().offset(-10)
        }

        endCoordinate.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.top.equalTo(startCoordinate.snp.bottom)
            make.height.equalTo(startCoordinate)
            make.width.equalToSuperview().offset(-10)
        }
    }
}
