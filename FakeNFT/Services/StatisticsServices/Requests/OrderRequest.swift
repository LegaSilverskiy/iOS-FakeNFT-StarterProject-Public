//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 23.08.2024.
//
import Foundation

struct OrderRequest: NetworkRequest {

    var httpMethod: HttpMethod
    var orderedNfts: [String]?
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var dtoEncoded: Data? {
        guard httpMethod == .put,
              let orderedNfts,
              !orderedNfts.isEmpty else {
            return nil
        }
        return ("nfts=\(orderedNfts.joined(separator: ","))").data(using: .utf8)
    }

    init(httpMethod: HttpMethod, orderedNfts: [String]?) {
        self.httpMethod = httpMethod
        if let orderedNfts {
            self.orderedNfts = orderedNfts
        }
    }
}
