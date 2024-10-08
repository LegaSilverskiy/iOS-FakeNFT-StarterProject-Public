//
//  EditProfileRequest.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 15.08.2024.
//

import Foundation

struct EditProfileRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod = .put

    var dtoEncoded: Data?

    init(profile: Profile) {
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "name", value: profile.name),
            URLQueryItem(name: "description", value: profile.description),
            URLQueryItem(name: "website", value: profile.website),
            URLQueryItem(name: "avatar", value: profile.avatar)
        ]

        if let queryString = components.percentEncodedQuery {
            self.dtoEncoded = queryString.data(using: .utf8)
        }
    }
}
