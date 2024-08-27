import Foundation

protocol CartCurrencyPresenterProtocol {
    var view: CartCurrencyView? { get set }
    func viewDidLoad()
    func didSelectCurrency(at indexPath: IndexPath)
    func userAgreementTapped()
    func getCurrencies() -> [CartCurrency]
    func processPayment()
    func getFailedPaymentAlertActions() -> [AlertButtonAction]
    func getSuccessFlow() -> CartSuccessPaymentController
}

final class CartCurrencyPresenter: CartCurrencyPresenterProtocol {
    
    weak var view: CartCurrencyView?
    private var currencies: [CartCurrency] = []
    private let service = OrderService.shared
    private let interactor: CartCurrencyInteractorProtocol
    private let cartCurrencyService: CartCurrencyServiceProtocol
    
    init(interactor: CartCurrencyInteractorProtocol, cartCurrencyService: CartCurrencyServiceProtocol) {
        self.interactor = interactor
        self.cartCurrencyService = cartCurrencyService
    }
    
    func viewDidLoad() {
        fetchCurrencies()
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
        guard let selectedCurrencyIndex = UserDefaults.standard.value(forKey: "SelectedCurrencyIndex") as? Int else {
            print("No currency selected")
            view?.showFailedPaymentAlert()
            return
        }
        
        let selectedCurrency = currencies[selectedCurrencyIndex]
        makePayment(by: selectedCurrency.id)
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
    
    private func fetchCurrencies() {
        interactor.fetchCurrencies { [weak self] result in
            switch result {
            case .success(let currencyModels):
                self?.cartCurrencyService.transformCurrencies(from: currencyModels) { [weak self] cartCurrencies in
                    if let cartCurrencies = cartCurrencies {
                        self?.currencies = cartCurrencies.sorted { $0.name < $1.name }
                        DispatchQueue.main.async {
                            self?.view?.reloadData()
                            self?.loadSelectedCurrency()
                        }
                    } else {
                        print("Failed to transform currencies")
                    }
                }
            case .failure(let error):
                print("Failed to fetch currencies: \(error)")
            }
        }
    }
    
    private func makePayment(by id: String)  {
        interactor.fetchPaymentRequest(for: id) { [weak self] result in
            switch result {
            case .success(let payment):
                if payment.success {
                    DispatchQueue.main.async {
                        self?.view?.showSuccessFlow()
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self?.view?.showFailedPaymentAlert()
                    }
                }
            case .failure(let error):
                print("Failed to fetch: \(error)")
            }
        }
        
    }
    
    private func loadSelectedCurrency() {
        if let savedIndex = UserDefaults.standard.value(forKey: "SelectedCurrencyIndex") as? Int {
            let selectedCurrencyIndex = IndexPath(row: savedIndex, section: 0)
            view?.selectCurrency(at: selectedCurrencyIndex)
        }
    }
}
