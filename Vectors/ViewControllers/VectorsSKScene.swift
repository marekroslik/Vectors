import SpriteKit

final class VectorsSKScene: SKScene {
    var vectors: [VectorModel]
    var movableNode: SKNode?
    var ballStartX: CGFloat = 0.0
    var ballStartY: CGFloat = 0.0
    var previousCameraPoint = CGPoint.zero

    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        self.view?.showsFPS = true
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGesture)
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: 0, y: 0)

        scene?.addChild(cameraNode)
        scene?.camera = cameraNode
        sceneSetUp()
    }

    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        // The camera has a weak reference, so test it
        guard let camera = self.camera else {
            return
        }
        // If the movement just began, save the first camera position
        if sender.state == .began {
            previousCameraPoint = camera.position
        }
        // Perform the translation
        let translation = sender.translation(in: self.view)
        let newPosition = CGPoint(
            x: previousCameraPoint.x + translation.x * -1,
            y: previousCameraPoint.y + translation.y
        )
        camera.position = newPosition
    }

    init(vectors: [VectorModel]) {
        self.vectors = vectors
        super.init(size: UIScreen.main.bounds.size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func drawVector(
        start: CGPoint,
        end: CGPoint,
        id: String,
        pointerLineLength: CGFloat = 1,
        arrowAngle: CGFloat = .pi / 6
    ) {
        self.childNode(withName: id)?.removeFromParent()
        let path = CGMutablePath()
        path.move(to: start)
        path.addLine(to: end)

        let startEndAngle = atan((end.y - start.y) / (end.x - start.x)) +
        ((end.x - start.x) < 0 ? CGFloat(Double.pi) : 0)
        let arrowLine1 = CGPoint(
            x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle + arrowAngle),
            y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle + arrowAngle)
        )
        let arrowLine2 = CGPoint(
            x: end.x + pointerLineLength * cos(CGFloat(Double.pi) - startEndAngle - arrowAngle),
            y: end.y - pointerLineLength * sin(CGFloat(Double.pi) - startEndAngle - arrowAngle)
        )
        path.addLine(to: arrowLine1)
        path.move(to: end)
        path.addLine(to: arrowLine2)
        let line = SKShapeNode(path: path)
        line.name = id
        line.strokeColor = UIColor.red
        line.lineWidth = 1
        line.lineJoin = .round
        line.lineCap = .round
        line.fillColor = UIColor.clear
        self.addChild(line)
    }

    func sceneSetUp() {
        for vector in vectors {
            drawVector(start: vector.start, end: vector.end, id: String(vector.id))
        }

    }
}
