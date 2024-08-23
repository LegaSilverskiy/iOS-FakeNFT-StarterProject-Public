//
//  NFTDetailsRequest.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 22.08.2024.
//
import Foundation

struct NFTDetailsRequest: NetworkRequest {
 
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
