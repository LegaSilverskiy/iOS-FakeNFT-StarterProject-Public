import Foundation

protocol CartCurrencyInteractorProtocol {
    func fetchCurrencies(completion: @escaping (Result<[CartCurrencyModel], Error>) -> Void)
    func fetchCurrencyByID(_ id: String, completion: @escaping (Result<CartCurrencyModel, Error>) -> Void)
    func fetchPaymentRequest(for currencyID: String, completion: @escaping (Result<OrderPayment, Error>) -> Void)
}

final class CartCurrencyInteractor: CartCurrencyInteractorProtocol {
    private let service = OrderService.shared

    func fetchCurrencies(completion: @escaping (Result<[CartCurrencyModel], Error>) -> Void) {
        service.fetchCurrencies { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchCurrencyByID(_ id: String, completion: @escaping (Result<CartCurrencyModel, Error>) -> Void) {
        service.fetchCurrencyByID(id) { result in
            switch result {
            case .success(let currency):
                completion(.success(currency))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchPaymentRequest(for currencyID: String, completion: @escaping (Result<OrderPayment, Error>) -> Void) {
        service.fetchPaymentRequest(for: currencyID) { result in
            switch result {
            case .success(let payment):
                completion(.success(payment))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
