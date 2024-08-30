//
//  FavoritesRequest.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 23.08.2024.
//
import Foundation

struct FavoritesRequest: NetworkRequest {

    let httpMethod: HttpMethod
    let noFavorites: String? = "likes=null"
    var favoriteNfts: [String]?
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var dtoEncoded: Data? {
        guard httpMethod == .put else {
            return nil
        }
        guard let favoriteNfts,
              !favoriteNfts.isEmpty else {
            return noFavorites?.data(using: .utf8)
        }
        return ("likes=\(favoriteNfts.joined(separator: ","))").data(using: .utf8)
    }

    init(httpMethod: HttpMethod, favoriteNfts: [String]?) {
        self.httpMethod = httpMethod
        if let favoriteNfts {
            self.favoriteNfts = favoriteNfts
        }
    }
}
