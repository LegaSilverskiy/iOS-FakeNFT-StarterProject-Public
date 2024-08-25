//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 23.08.2024.
//
import Foundation

struct OrderRequest: NetworkRequest {

    var httpMethod: HttpMethod
    var orderedNtfs: [String]?
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    init(httpMethod: HttpMethod, orderedNtfs: [String]?) {
        self.httpMethod = httpMethod
        if let orderedNtfs {
            self.orderedNtfs = orderedNtfs
        }
    }
}
