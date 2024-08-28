//
//  OrderService.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/26/24.
//

import Foundation

typealias OrderCompletion = (Result<Order, Error>) -> Void

final class OrderServiceImpl {
    
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.networkClient = networkClient
        self.storage = storage
        loadOrders { _ in }
    }
    
    func loadOrders(completion: @escaping OrderCompletion) {
        let request = OrderRequest()
        networkClient.send(request: request, type: Order.self) { [weak storage] result in
            switch result {
            case .success(let orders):
                storage?.saveOrderId(orderId: orders.id)
                orders.nfts.forEach {
                    storage?.saveOrders($0)
                }
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cartState(for id: String) -> Bool {
        storage.findInOrders(id)
    }
}

