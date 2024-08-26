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

    var dto: (any Encodable)? {
        guard let orderedNtfs else {
            return nil
        }
        return ("nfts=\(orderedNtfs.joined(separator: ","))")
    }

    init(httpMethod: HttpMethod, orderedNtfs: [String]?) {
        self.httpMethod = httpMethod
        if let orderedNtfs {
            self.orderedNtfs = orderedNtfs
        }
    }
}
