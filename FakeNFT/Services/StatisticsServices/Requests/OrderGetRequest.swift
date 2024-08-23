//
//  OrderGetRequest.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 23.08.2024.
//
import Foundation

struct OrderGetRequest: NetworkRequest {
 
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
