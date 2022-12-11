import SnapKit
import RxSwift
import RxCocoa

class AddViewController: UIViewController {

    var addVector: ((VectorModel) -> Void)?

    private let addView = AddView()

    override func viewDidLoad() {
        self.view.backgroundColor = .black
        addSubviews()
        setupConstraints()
        addView.acceptButtonCompletionHandler = { [weak self] vector in
            let start = vector.start
            let end = vector.end
            self?.addVector?(VectorModel(start: start, end: end))
        }
    }

    private func addSubviews() {
        view.addSubview(addView)
    }

    private func setupConstraints() {
        addView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
