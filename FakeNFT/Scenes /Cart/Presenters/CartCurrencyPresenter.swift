import Foundation

protocol CartCurrencyView: AnyObject {
    func reloadData()
    func selectCurrency(at indexPath: IndexPath)
    func navigateToUserAgreement()
    func showFailedPaymentAlert() 
    func showSuccessFlow()
}

final class CartCurrencyPresenter {
    weak var view: CartCurrencyView?
    private var currencies: [CartCurrency] = []
    
    func viewDidLoad() {
        currencies = Mock.shared.currencies
        loadSelectedCurrency()
    }

    func didSelectCurrency(at indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "SelectedCurrencyIndex")
    }
    
    func userAgreementTapped() {
        view?.navigateToUserAgreement()
    }
    
    func getCurrencies() -> [CartCurrency] {
        currencies
    }
    
    func processPayment() {
        isSuccessPayment() ? view?.showFailedPaymentAlert() : view?.showSuccessFlow()
    }
    
    func getFailedPaymentAlertActions() -> [AlertButtonAction] {
        let actions = [
            AlertButtonAction(
                buttonTitle: "Отменить",
                style: .cancel,
                action: nil
            ),
            
            AlertButtonAction(
                buttonTitle: "Повторить",
                style: .default) { [weak self] action in
                    guard let self else { return }
                    processPayment()
                }
        ]
        
        return actions
    }
    
    func getSuccessFlow() -> CartSuccessPaymentController {
        let vc = CartSuccessPaymentController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        return vc
    }
    
    private func isSuccessPayment() -> Bool {
        Bool.random()
    }
    
    private func loadSelectedCurrency() {
        if let savedIndex = UserDefaults.standard.value(forKey: "SelectedCurrencyIndex") as? Int {
            let selectedCurrencyIndex = IndexPath(row: savedIndex, section: 0)
            view?.selectCurrency(at: selectedCurrencyIndex)
        }
    }
}
