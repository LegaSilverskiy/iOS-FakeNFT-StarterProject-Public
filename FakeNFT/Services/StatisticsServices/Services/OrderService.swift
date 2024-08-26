//
//  OrderService.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 23.08.2024.
//
import Foundation

protocol OrderServiceProtocol {
    func sendOrderRequest(httpMethod: HttpMethod, orderedNfts: [String]?, completion: @escaping OrderCompletion)
}

typealias OrderCompletion = (Result<Order, Error>) -> Void

final class OrderService: OrderServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func sendOrderRequest(httpMethod: HttpMethod, orderedNfts: [String]?, completion: @escaping OrderCompletion) {
        let request = OrderRequest(httpMethod: httpMethod, orderedNtfs: orderedNfts)
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
