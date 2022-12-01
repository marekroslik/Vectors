import SnapKit
import SpriteKit

final class CanvasViewController: UIViewController {

    private let vectors = [
        VectorModel(
            id: "1",
            start: CGPoint(
                x: 0,
                y: 0
            ),
            end: CGPoint(
                x: 1,
                y: 1
            )),
        VectorModel(
            id: "2",
            start: CGPoint(
                x: 2,
                y: 2
            ),
            end: CGPoint(
                x: 3,
                y: 3
            )),
        VectorModel(
            id: "3",
            start: CGPoint(
                x: 4,
                y: 4
            ),
            end: CGPoint(
                x: 5,
                y: 5
            )),
        VectorModel(
            id: "4",
            start: CGPoint(
                x: 6,
                y: 6
            ),
            end: CGPoint(
                x: 7,
                y: 7
            )),
        VectorModel(
            id: "5",
            start: CGPoint(
                x: 8,
                y: 8
            ),
            end: CGPoint(
                x: 9,
                y: 9
            ))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }

    override func loadView() {
        super.loadView()
        self.view = SKView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupScene()
    }
    func setupScene() {
        if let view = self.view as? SKView {
            view.showsFPS = true
            view.showsNodeCount = true
            view.ignoresSiblingOrder = true
            let scene = VectorsSKScene(vectors: vectors, size: view.frame.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
