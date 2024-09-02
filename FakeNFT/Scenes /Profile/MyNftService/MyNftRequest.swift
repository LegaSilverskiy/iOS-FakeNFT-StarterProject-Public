//
//  MyNftRequest.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 19.08.2024.
//

import Foundation

struct MyNftRequest: NetworkRequest {

    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
