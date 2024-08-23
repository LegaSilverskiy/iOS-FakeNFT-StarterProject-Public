import Foundation

protocol CartCurrencyView: AnyObject {
    func reloadData()
    func selectCurrency(at indexPath: IndexPath)
    func navigateToUserAgreement()
}

final class CartCurrencyPresenter {
    weak var view: CartCurrencyView?
    private var currencies: [String] = []
    
    func viewDidLoad() {
        loadSelectedCurrency()
    }

    func didSelectCurrency(at indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "SelectedCurrencyIndex")
    }
    
    func userAgreementTapped() {
        view?.navigateToUserAgreement()
    }
    
    private func loadSelectedCurrency() {
        if let savedIndex = UserDefaults.standard.value(forKey: "SelectedCurrencyIndex") as? Int {
            let selectedCurrencyIndex = IndexPath(row: savedIndex, section: 0)
            view?.selectCurrency(at: selectedCurrencyIndex)
        }
    }
}
