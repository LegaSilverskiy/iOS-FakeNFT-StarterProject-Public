import Foundation

protocol UserAgreementPresenterProtocol: AnyObject {
    var view: UserAgreementView? { get set }
    func viewDidLoad()
    func backButtonPressed()
}

final class UserAgreementPresenter: UserAgreementPresenterProtocol {
    weak var view: UserAgreementView?

    func viewDidLoad() {
        setupView()
        loadUserAgreement()
    }

    func backButtonPressed() {
        view?.dismissView()
    }

    private func setupView() {
        view?.setNavigationTitle(.cartUserAgreement)
    }

    private func loadUserAgreement() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else { return }
        let request = URLRequest(url: url)
        view?.loadUserAgreement(with: request)
    }
}
