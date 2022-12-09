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
            self?.addVector?(vector)
        }

    }

    @objc private func addButtonTaped() {
        let vector = VectorModel(id: "3", start: .zero, end: .zero)
        self.addVector?(vector)
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
