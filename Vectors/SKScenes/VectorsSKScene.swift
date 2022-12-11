import SpriteKit
import RxSwift
import RxCocoa

final class VectorsSKScene: SKScene {
    typealias Touch = (CGPoint, UIGestureRecognizer.State)

    private let blockSize: CGFloat = 100
    private let innerSize: CGFloat = 1000

    private let panGesture = UIPanGestureRecognizer()

    override func didMove(to view: SKView) {
        drawGrid()
        addCamera()
        addGestures()
    }
}

// MARK: - Work with vectors
extension VectorsSKScene {
    func draw(
        vector: VectorModel,
        arrowAngle: CGFloat = .pi / 6
    ) {
        let pointerLineLength = blockSize / 5
        let start = CGPoint(x: vector.start.x * blockSize, y: vector.start.y * blockSize)
        let end = CGPoint(x: vector.end.x * blockSize, y: vector.end.y * blockSize)
        self.childNode(withName: vector.id)?.removeFromParent()
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
        line.name = vector.id
        line.strokeColor = vector.color
        line.lineWidth = blockSize / 50
        line.lineJoin = .round
        line.lineCap = .round
        line.fillColor = UIColor.clear
        self.addChild(line)
    }

    func deleteVector(id: String) {
        self.childNode(withName: id)?.removeFromParent()
    }

    func showVector(id: String) {
        guard let vector = self.childNode(withName: id) else { return }
        scene?.camera?.position.x = vector.frame.midX
        scene?.camera?.position.y = vector.frame.midY
        playSelectAnimation(node: vector)
    }

    private func playSelectAnimation(node: SKNode) {
        let fadeAlphaFirst = SKAction.fadeAlpha(to: 0, duration: TimeInterval(0.1))
        let fadeAlphaSecond = SKAction.fadeAlpha(to: 1, duration: TimeInterval(0.1))
        let fadeSequence = SKAction.sequence([fadeAlphaFirst, fadeAlphaSecond])
        let repeatAction = SKAction.repeat(fadeSequence, count: 3)
        node.run(repeatAction)
    }
}

// MARK: - Add gestures
extension VectorsSKScene {
    func panGestureObserver() -> Observable<Touch> {
        panGesture
            .rx
            .event
            .flatMap { [weak self] recognizer -> Observable<Touch> in
                guard let self = self else { return Observable.never() }
                let pointInView = recognizer.location(in: self.view)
                let pointInScene = self.convertPoint(fromView: pointInView)
                let convertPoint = pointInScene.convertFrom(multiplyScalar: self.blockSize)
                return(Observable.just((convertPoint, recognizer.state)))
            }
    }

    func moveTheCamera(xDelta: CGFloat, yDelta: CGFloat) {
        guard
            let positionX = camera?.position.x,
            let positionY = camera?.position.y
        else { return }

        let newPositionX = positionX - xDelta * blockSize
        let newPositionY = positionY - yDelta * blockSize

        let limitationConstX = innerSize - frame.width / 2
        let limitationConstY = innerSize - frame.height / 2

        let limitationRangeX = (-limitationConstX...limitationConstX)
        let limitationRangeY = (-limitationConstY...limitationConstY)

        if limitationRangeX.contains(newPositionX) {
            camera?.position.x = newPositionX
        }
        if limitationRangeY.contains(newPositionY) {
            camera?.position.y = newPositionY
        }
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

    private func addPanGesture() {
        view?.addGestureRecognizer(panGesture)
    }

    private func addGestures() {
        doubleTapChangeCameraPosition()
        addPanGesture()
    }
}

// MARK: - Work with background
extension VectorsSKScene {
    private func drawGrid() {
        self.backgroundColor = .black
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
