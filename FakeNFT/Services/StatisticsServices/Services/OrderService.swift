//
//  OrderService.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 23.08.2024.
//
import Foundation

protocol OrderServiceProtocol {
    func loadOrder(completion: @escaping OrderCompletion)
}

typealias OrderCompletion = (Result<Order, Error>) -> Void

final class OrderService: OrderServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadOrder(completion: @escaping OrderCompletion) {
        let request = OrderGetRequest()
        networkClient.send(request: request, type: Order.self) {result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
