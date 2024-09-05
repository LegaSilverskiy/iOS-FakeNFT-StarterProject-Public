//
//  FavouritesRequest.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 22.08.2024.
//

import Foundation

final class FavouritesRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod = .put

    var dtoEncoded: Data?

    init(profile: Profile) {
        let likeStr = profile.likes.joined(separator: ", ")

        var components = URLComponents()

        let likeValue = !likeStr.isEmpty ? likeStr : "null"

        components.queryItems = [
            URLQueryItem(name: "likes", value: likeValue)
        ]

        if let queryString = components.percentEncodedQuery {
            self.dtoEncoded = queryString.data(using: .utf8)
        }
    }
}
