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
        view?.setNavigationTitle("Пользовательское соглашение")
    }
    
    private func loadUserAgreement() {
        if let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") {
            let request = URLRequest(url: url)
            view?.loadUserAgreement(with: request)
        }
    }
}
