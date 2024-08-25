//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 23.08.2024.
//
import Foundation

struct FavoritesRequest: NetworkRequest {

    var httpMethod: HttpMethod
    var favoriteNfts: [String]?
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    init(httpMethod: HttpMethod, favoriteNfts: [String]?) {
        self.httpMethod = httpMethod
        if let favoriteNfts {
            self.favoriteNfts = favoriteNfts
        }
    }
}
