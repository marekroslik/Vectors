import SpriteKit

final class VectorsSKScene: SKScene {
    private var vectors: [VectorModel]

    private var movableNode: SKNode?
    private var action: Actions?

    enum Actions {
        case editVectorStartPosition
        case editVectorEndPosition
        case vectorParallelTranslation
        case moveTheСamera
    }

    private let blockSize: CGFloat = 100
    private let innerSize: CGFloat = 1000

    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        drawGrid()
        redrawVectors()
        addCamera()
        addGestures()
    }

    init(
        vectors: [VectorModel],
        size: CGSize
    ) {
        self.vectors = vectors
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Work with vectors
extension VectorsSKScene {
    private func drawVector(
        start: CGPoint,
        end: CGPoint,
        id: String,
        arrowAngle: CGFloat = .pi / 6
    ) {

        let pointerLineLength = blockSize / 5
        let start = CGPoint(x: start.x * blockSize, y: start.y * blockSize)
        let end = CGPoint(x: end.x * blockSize, y: end.y * blockSize)
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
        line.strokeColor = UIColor.white
        line.lineWidth = blockSize / 50
        line.lineJoin = .round
        line.lineCap = .round
        line.fillColor = UIColor.clear
        self.addChild(line)
    }

    private func redrawVectors() {
        for vector in vectors {
            drawVector(start: vector.start, end: vector.end, id: String(vector.id))
        }
    }

    private func showVector(id: Int) {
        guard let coordinates = self.childNode(withName: String(id))?.position else { return }
        scene?.camera?.position = coordinates
    }
}

// MARK: - Add gestures
extension VectorsSKScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let coordinates = touches.first?.location(in: self) {
            if
                let node: SKNode = self.nodes(at: coordinates).first,
                let vector = vectors.first(
                    where: {
                        $0.id == node.name
                    }
                ) {
                movableNode = node
                let tolerance: CGFloat = 20

                let startToleranceX = (
                    vector.start.x * blockSize - tolerance
                )...(
                    vector.start.x * blockSize + tolerance
                )
                let startToleranceY = (
                    vector.start.y * blockSize - tolerance
                )...(
                    vector.start.y  * blockSize + tolerance
                )

                let endToleranceX = (
                    vector.end.x * blockSize - tolerance
                )...(
                    vector.end.x * blockSize + tolerance
                )
                let endToleranceY = (
                    vector.end.y * blockSize - tolerance
                )...(
                    vector.end.y  * blockSize + tolerance
                )
                if (startToleranceX).contains(coordinates.x) && (startToleranceY).contains(coordinates.y) {
                    action = .editVectorStartPosition
                } else if (endToleranceX).contains(coordinates.x) && (endToleranceY).contains(coordinates.y) {
                    action = .editVectorEndPosition
                } else {
                    action = .vectorParallelTranslation
                }
            } else {
                action = .moveTheСamera
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard
            let touchFirstX = touches.first?.location(in: self).x,
            let touchPreviousX = touches.first?.previousLocation(in: self).x,
            let touchFirstY = touches.first?.location(in: self).y,
            let touchPreviousY = touches.first?.previousLocation(in: self).y
        else { return }
        switch action {
        case .editVectorStartPosition:
            actionEditVector(startX: touchFirstX, startY: touchFirstY)
        case .editVectorEndPosition:
            actionEditVector(endX: touchFirstX, endY: touchFirstY)
        case .vectorParallelTranslation:
            let xDelta = touchFirstX  - touchPreviousX
            let yDelta = touchFirstY  - touchPreviousY
            actionVectorParallelTranslation(xDelta: xDelta, yDelta: yDelta)
        case .moveTheСamera:
            let xDelta = touchFirstX  - touchPreviousX
            let yDelta = touchFirstY  - touchPreviousY
            moveTheCamera(xDelta: xDelta, yDelta: yDelta)
        default:
            return
        }
    }

    private func actionEditVector(startX: CGFloat, startY: CGFloat) {
        if let movableNode, let indexMovableNode = vectors.firstIndex(where: { $0.id == movableNode.name }) {
            vectors[indexMovableNode].start = CGPoint(x: startX / blockSize, y: startY / blockSize)
            drawVector(
                start: vectors[indexMovableNode].start,
                end: vectors[indexMovableNode].end,
                id: vectors[indexMovableNode].id
            )
        }
    }

    private func actionEditVector(endX: CGFloat, endY: CGFloat) {
        if let movableNode, let indexMovableNode = vectors.firstIndex(where: { $0.id == movableNode.name }) {
            vectors[indexMovableNode].end = CGPoint(x: endX / blockSize, y: endY / blockSize)
            drawVector(
                start: vectors[indexMovableNode].start,
                end: vectors[indexMovableNode].end,
                id: vectors[indexMovableNode].id
            )
        }
    }

    private func actionVectorParallelTranslation(xDelta: CGFloat, yDelta: CGFloat) {
        if let movableNode, let indexMovableNode = vectors.firstIndex(where: { $0.id == movableNode.name }) {
            vectors[indexMovableNode].start.x += xDelta / blockSize
            vectors[indexMovableNode].start.y += yDelta / blockSize
            vectors[indexMovableNode].end.x += xDelta / blockSize
            vectors[indexMovableNode].end.y += yDelta / blockSize
            movableNode.position = CGPoint(
                x: movableNode.position.x + xDelta,
                y: movableNode.position.y + yDelta
            )
        }
    }

    private func moveTheCamera(xDelta: CGFloat, yDelta: CGFloat) {
        camera?.position.x -= xDelta
        camera?.position.y -= yDelta
    }

    override  func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movableNode = nil
        action = nil
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        movableNode = nil
        action = nil
    }

    private func addGestures() {
        doubleTapChangeCameraPosition()
    }

    private func doubleTapChangeCameraPosition() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(doubleTapChangeCameraPosition(_:)))
        tapGesture.numberOfTapsRequired = 2
        view?.addGestureRecognizer(tapGesture)
    }

    @objc private func doubleTapChangeCameraPosition(_ sender: UIPanGestureRecognizer) {
        camera?.position = CGPoint.zero
    }
}

// MARK: - Work with background
extension VectorsSKScene {
    private func drawGrid() {
        drawVerticalLines()
        drawHorizontalLines()
        drawVerticalNumbers()
        drawHorizontalNumbers()
    }

    private func drawVerticalLines() {
        for index in stride(from: -innerSize, through: innerSize, by: blockSize) {
            let line = SKShapeNode()
            let pathToDraw = CGMutablePath()
            pathToDraw.move(to: CGPoint(x: -innerSize, y: index))
            pathToDraw.addLine(to: CGPoint(x: innerSize, y: index))
            line.path = pathToDraw
            line.strokeColor = SKColor.darkGray
            line.lineWidth = 1
            line.isUserInteractionEnabled = true
            addChild(line)
        }
    }

    private func drawHorizontalLines() {
        for index in stride(from: -innerSize, through: innerSize, by: blockSize) {
            let line = SKShapeNode()
            let pathToDraw = CGMutablePath()
            pathToDraw.move(to: CGPoint(x: index, y: -innerSize))
            pathToDraw.addLine(to: CGPoint(x: index, y: innerSize))
            line.path = pathToDraw
            line.strokeColor = SKColor.darkGray
            line.lineWidth = 1
            line.isUserInteractionEnabled = true
            addChild(line)
        }
    }
    private func drawVerticalNumbers() {
        for index in stride(from: -innerSize, through: innerSize, by: blockSize) {
            let label = SKLabelNode()
            label.text = "\(Int(index/blockSize))"
            label.fontSize = blockSize / 5
            label.fontColor = UIColor.white
            label.position = CGPoint(x: -(blockSize / 20), y: index + blockSize / 20)
            label.isUserInteractionEnabled = true
            label.horizontalAlignmentMode = .right
            addChild(label)
        }
    }

    private func drawHorizontalNumbers() {
        for index in stride(from: -innerSize, through: innerSize, by: blockSize) {
            let label = SKLabelNode()
            label.text = "\(Int(index/blockSize))"
            label.fontSize = blockSize / 5
            label.fontColor = UIColor.white
            label.position = CGPoint(x: index - blockSize / 20, y: blockSize / 20)
            label.isUserInteractionEnabled = true
            label.horizontalAlignmentMode = .right
            addChild(label)
        }
    }
}

// MARK: - Add camera
extension VectorsSKScene {
    private func addCamera() {
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint.zero
        scene?.addChild(cameraNode)
        scene?.camera = cameraNode
    }
}
