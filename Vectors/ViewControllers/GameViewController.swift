import SnapKit

final class GameViewController: UIViewController {
    private let gameView = GameView()
    private let moneyLabel = UILabel()
    private var moneyValue = 100.0

    private var ball: UIView?

    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var collision: UICollisionBehavior!

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        setupAnimator()
        self.updateMoney(value: 100)
    }

    override func viewDidLayoutSubviews() {
        gameView.gridView.layoutIfNeeded()
        print(gameView.gridView.frame)
        createGrid()
    }

    private func setupAnimator() {
        self.animator = UIDynamicAnimator(referenceView: gameView)
        self.gravity = UIGravityBehavior()
        animator.addBehavior(gravity)
        self.collision = UICollisionBehavior()
        collision.collisionMode = .everything
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        animator.addBehavior(collision)
    }

    private func start() {
        if self.moneyValue < 10 { return }
        self.updateMoney(value: self.moneyValue - 10)
        let ball: CircleView = {
            let size: CGFloat = 20
            let view = CircleView(frame: CGRect(
                x: gameView.gridView.frame.midX + .random(in: -20...20),
                y: 20, width: size, height: size
            ))
            view.backgroundColor = .white
            view.layer.cornerRadius = size / 2
            return view
        }()
        gameView.gridView.addSubview(ball)
        gravity.addItem(ball)
        let itemBehavior = UIDynamicItemBehavior(items: [ball])
        itemBehavior.elasticity = 0.3
        animator.addBehavior(itemBehavior)
        collision.addItem(ball)
    }

    private func updateMoney(value: Double) {
        self.moneyValue = value
        self.moneyLabel.text = String(format: "%.2f $", value)
    }

    private func createGrid() {
        let widthCount: Int = 9
        let drawStride: CGFloat = gameView.frame.width / CGFloat(widthCount)
        let maxX = gameView.frame.maxX
        let count = (gameView.frame.height - 100) / drawStride

        for index in 1...Int(count) {
            if index % 2 == 0 {
                for coordinateX in stride(from: drawStride / 2, to: maxX, by: drawStride) {
                    let point = CGPoint(x: coordinateX, y: CGFloat(index) * drawStride)
                    createBarriers(point: point)
                }
            } else {
                for coordinateX in stride(from: 0, to: maxX, by: drawStride) {
                    let point = CGPoint(x: coordinateX, y: CGFloat(index) * drawStride)
                    createBarriers(point: point)
                }
            }
        }
    }

    private func createBarriers(point: CGPoint) {
        let barrier: CircleView = {
            let size: CGFloat = 10
            let view = CircleView(frame: CGRect(x: point.x, y: point.y, width: size, height: size))
            view.backgroundColor = .darkGray
            view.layer.cornerRadius = size / 2
            return view
        }()
        gameView.gridView.addSubview(barrier)
        collision.addBoundary(withIdentifier: UUID().uuidString as NSCopying, for: UIBezierPath(ovalIn: barrier.frame))
    }

    private func addSubviews() {
        self.view.addSubview(gameView)
        self.view.addSubview(moneyLabel)
    }

    private func addConstraints() {
        gameView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        moneyLabel.snp.makeConstraints { make in
            make.top.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension GameViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(
        _ behavior: UICollisionBehavior,
        beganContactFor item: UIDynamicItem,
        withBoundaryIdentifier identifier: NSCopying?,
        at point: CGPoint
    ) {
        if let collidingView = item as? UIView {
            if point.y >= gameView.endArea1.frame.minY {
                if gameView.endArea1.frame.contains(point) {
                    updateMoney(value: self.moneyValue + 50)
                } else
                if gameView.endArea2.frame.contains(point) {
                    updateMoney(value: self.moneyValue + 20)
                } else
                if gameView.endArea3.frame.contains(point) {
                } else
                if gameView.endArea4.frame.contains(point) {
                    updateMoney(value: self.moneyValue + 20)
                } else
                if gameView.endArea5.frame.contains(point) {
                    updateMoney(value: self.moneyValue + 50)
                }
                collision.removeItem(item)
                collidingView.removeFromSuperview()
            }
        }
    }
}

    extension GameViewController {
        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if event?.subtype == .motionShake {
                start()
            }
            if super.responds(to: #selector(UIResponder.motionEnded(_:with:))) {
                super.motionEnded(motion, with: event)
            }
        }

        override var canBecomeFirstResponder: Bool { return true }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        }

        override func viewWillDisappear(_ animated: Bool) {
            self.resignFirstResponder()
            super.viewWillDisappear(animated)
        }
    }
