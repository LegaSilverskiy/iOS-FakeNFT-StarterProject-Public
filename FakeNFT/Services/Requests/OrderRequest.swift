//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/26/24.
//

import Foundation

struct OrderRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct OrderPutRequest: NetworkRequest {
    
    let httpMethod: HttpMethod = .put
    var id: String
    var orders: [String]
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var body: Data? {
        return ordersToString().data(using: .utf8)
    }
    
    init(id: String, orders: [String]) {
        self.orders = orders
        self.id = id
    }
    
    private func ordersToString() -> String {
        var ordersString = "nfts="
        if orders.isEmpty {
            ordersString += ""
        } else {
            for (index, order) in orders.enumerated() {
                ordersString += order
                if index != orders.count - 1 {
                    ordersString += "&nfts="
                }
            }
        }
        ordersString += "&id=\(id)"
        return ordersString
    }
}
