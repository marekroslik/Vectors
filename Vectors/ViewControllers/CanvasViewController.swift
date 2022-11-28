import SpriteKit
import SnapKit

final class CanvasViewController: UIViewController {

    private var sceneView = UIView()
    private var scene: VectorsSKScene?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        super.loadView()
        self.view = SKView()
        self.view.bounds = UIScreen.main.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupScene()
    }

    func setupScene() {
        let vectors = [
            VectorModel(
                id: 1,
                start: CGPoint(
                    x: 0,
                    y: 0
                ),
                end: CGPoint(
                    x: 1,
                    y: 1
                )),
            VectorModel(
                id: 2,
                start: CGPoint(
                    x: 2,
                    y: 2
                ),
                end: CGPoint(
                    x: 3,
                    y: 3
                )),
            VectorModel(
                id: 3,
                start: CGPoint(
                    x: 4,
                    y: 4
                ),
                end: CGPoint(
                    x: 5,
                    y: 5
                )),
            VectorModel(
                id: 4,
                start: CGPoint(
                    x: 6,
                    y: 6
                ),
                end: CGPoint(
                    x: 7,
                    y: 7
                )),
            VectorModel(
                id: 5,
                start: CGPoint(
                    x: 8,
                    y: 8
                ),
                end: CGPoint(
                    x: 9,
                    y: 9
                ))
        ]
        if let view = self.view as? SKView, scene == nil {
            let scene = VectorsSKScene(vectors: vectors)
            view.presentScene(scene)
            self.scene = scene
        }
    }
}
