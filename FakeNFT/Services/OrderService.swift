//
//  OrderService.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/26/24.
//

import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

final class OrderService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadOrders(completion: @escaping OrderCompletion) {
        let request = OrderRequest()
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setOrders(id: String, orders: [String], completion: @escaping OrderCompletion) {
        let request = OrderPutRequest(id: id, orders: orders)
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

