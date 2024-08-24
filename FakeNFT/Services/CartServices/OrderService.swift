import Foundation

final class OrderService {
    static let shared = OrderService()
    private init() {}
    
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
    
    func updateOrder(nftsIds: [String], completion: @escaping (Error?) -> Void) {
        let nftsString = nftsIds.joined(separator: ",")
        
        let bodyString = !nftsIds.isEmpty ? "nfts=\(nftsString)" : ""
        guard let bodyData = bodyString.data(using: .utf8) else { return }
        
        guard let url = URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/orders/1") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("67a24255-5ef3-4989-bbdc-84b70a80e456", forHTTPHeaderField: "X-Practicum-Mobile-Token")
        request.httpBody = nftsIds.isEmpty ? nil : bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
        
        task.resume()
    }
    
    private func create(request: NetworkRequest) -> URLRequest? {
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
}
