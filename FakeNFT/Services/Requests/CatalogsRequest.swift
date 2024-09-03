//
//  CatalogsRequest.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/19/24.
//

import Foundation

struct CatalogsRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections"
        )
    }
}
