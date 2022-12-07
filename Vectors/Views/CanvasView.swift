import SnapKit
import SpriteKit

final class CanvasView: UIView {
    private let sceneView: SKView = {
        let scene = SKView()
        scene.ignoresSiblingOrder = true
        #if DEBUG
        scene.showsFPS = true
        scene.showsNodeCount = true
        #endif
        return scene
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        sceneView.scene?.size = self.frame.size
    }

    func setupWith(scene: SKScene) {
        self.sceneView.presentScene(scene)
    }

    private func addSubviews() {
        addSubview(sceneView)
    }

    private func addConstraints() {
        sceneView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
