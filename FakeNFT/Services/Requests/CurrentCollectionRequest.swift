//
//  CurrentCollectionRequest.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/23/24.
//

import Foundation

struct CurrentCollectionRequest: NetworkRequest {
    
    let idCollection: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections/\(idCollection)")
    }
}
