import Foundation

protocol CartCurrencyServiceProtocol {
    func transformCurrencies(from currencyModels: [CartCurrencyModel], completion: @escaping ([CartCurrency]?) -> Void)
}

final class CartCurrencyService: CartCurrencyServiceProtocol {
    private let interactor: CartCurrencyInteractorProtocol
    
    init(interactor: CartCurrencyInteractorProtocol) {
        self.interactor = interactor
    }
    
    func transformCurrencies(from currencyModels: [CartCurrencyModel], completion: @escaping ([CartCurrency]?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var cartCurrencies: [CartCurrency] = []
        var fetchError: Error?

        for currencyModel in currencyModels {
            dispatchGroup.enter()
            interactor.fetchCurrencyByID(currencyModel.id) { result in
                switch result {
                case .success(let currencyByID):
                    let cartCurrency = CartCurrency(
                        title: currencyModel.title,
                        name: currencyByID.id, 
                        image: currencyModel.image,
                        id: currencyModel.id
                    )
                    cartCurrencies.append(cartCurrency)
                case .failure(let error):
                    fetchError = error
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if let error = fetchError {
                print("Failed to fetch currency by ID: \(error)")
                completion(nil)
            } else {
                completion(cartCurrencies)
            }
        }
    }
}
