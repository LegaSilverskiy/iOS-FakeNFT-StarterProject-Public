import Foundation

struct GetNFTByIDRequest: NetworkRequest {
    let end: String
    
    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)/api/v1/\(end)")
    }
    var httpMethod: HttpMethod { .get }
    var dto: Encodable? { nil }
}


final class OrderService {
    static let shared = OrderService()
    
    func fetchOrders(completion: @escaping (Result<Order, Error>) -> Void) {
        let request = GetNFTByIDRequest(end: "orders/1")

        guard let urlRequest = create(request: request) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URLRequest"])))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let nftResponse = try JSONDecoder().decode(Order.self, from: data)
                completion(.success(nftResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else {
            assertionFailure("Empty endpoint")
            return nil
        }

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        for (key, value) in RequestConstants.headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if let dto = request.dto,
           let dtoEncoded = try? JSONEncoder().encode(dto) {
            urlRequest.httpBody = dtoEncoded
        }

        return urlRequest
    }

    func fetchNFTByID(nftID: String, completion: @escaping (Result<CartNft, Error>) -> Void) {
        let request = GetNFTByIDRequest(end: "nft/\(nftID)")

        guard let urlRequest = create(request: request) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create URLRequest"])))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let nft = try JSONDecoder().decode(CartNft.self, from: data)
                completion(.success(nft))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
