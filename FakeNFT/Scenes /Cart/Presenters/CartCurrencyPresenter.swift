import Foundation

protocol CartCurrencyPresenterProtocol {
    var view: CartCurrencyView? { get set }
    func viewDidLoad()
    func didSelectCurrency(at indexPath: IndexPath)
    func isCurrencySelected() -> Bool
    func userAgreementTapped()
    func getCurrencies() -> [CartCurrency]
    func processPayment()
    func getFailedPaymentAlertActions() -> [AlertButtonAction]
    func getSuccessFlow() -> CartSuccessPaymentController
}

final class CartCurrencyPresenter: CartCurrencyPresenterProtocol {

    weak var view: CartCurrencyView?
    private var currencies: [CartCurrency] = []
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

    func isCurrencySelected() -> Bool {
        if UserDefaults.standard.value(forKey: "SelectedCurrencyIndex") is Int { return true }
        return false
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
                buttonTitle: .errorCancel,
                style: .cancel,
                action: nil
            ),

            AlertButtonAction(
                buttonTitle: .errorRepeat,
                style: .default) { [weak self] _ in
                    guard let self else { return }
                    processPayment()
                }
        ]

        return actions
    }

    func getSuccessFlow() -> CartSuccessPaymentController {
        let viewController = CartSuccessPaymentController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve

        return viewController
    }

    private func fetchCurrencies() {
        view?.showHud()
        interactor.fetchCurrencies { [weak self] result in
            switch result {
            case .success(let currencyModels):
                self?.cartCurrencyService.transformCurrencies(from: currencyModels) { [weak self] cartCurrencies in
                    guard let cartCurrencies else { return }
                    self?.currencies = cartCurrencies.sorted { $0.name < $1.name }
                    DispatchQueue.main.async {
                        self?.view?.reloadData()
                        self?.loadSelectedCurrency()
                        self?.view?.hideHud()
                    }
                }
            case .failure(let error):
                print("Failed to fetch currencies: \(error)")
            }
        }
    }

    private func makePayment(by id: String) {
        view?.showHud()
        interactor.fetchPaymentRequest(for: id) { [weak self] result in
            switch result {
            case .success(let payment):
                DispatchQueue.main.async {
                    self?.handlePaymentRequest(isSuccess: payment.success)
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

    private func handlePaymentRequest(isSuccess: Bool) {
        if isSuccess {
            view?.showSuccessFlow()
            view?.hideHud()
        } else {
            view?.showFailedPaymentAlert()
            view?.hideHud()
        }
    }
}
