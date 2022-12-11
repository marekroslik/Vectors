import RxSwift
import RxCocoa

extension Observable {
    func asDriverIgnoringErrors() -> Driver<Element> {
        return self
            .asDriver { _ in
                return .never()
            }
    }
}
