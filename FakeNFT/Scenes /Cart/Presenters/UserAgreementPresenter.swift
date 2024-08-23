import Foundation

protocol UserAgreementView: AnyObject {
    func loadUserAgreement(with request: URLRequest)
    func setNavigationTitle(_ title: String)
    func dismissView()
}

final class UserAgreementPresenter {
    weak var view: UserAgreementView?
    
    func viewDidLoad() {
        setupView()
        loadUserAgreement()
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
    
    func backButtonPressed() {
        view?.dismissView()
    }
}
