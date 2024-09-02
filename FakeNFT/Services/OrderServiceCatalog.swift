//
//  OrderService.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/26/24.
//

import Foundation

typealias OrderCompl = (Result<OrderForCatalog, Error>) -> Void

final class OrderServiceCatalog {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadOrders(completion: @escaping OrderCompl) {
        let request = OrderRequestCatalog()
        networkClient.send(request: request, type: OrderForCatalog.self) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setOrders(id: String, orders: [String], completion: @escaping OrderCompl) {
        let request = OrderPutRequestCatalog(id: id, orders: orders)
        networkClient.send(request: request, type: OrderForCatalog.self) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

