//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/26/24.
//

import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

struct LikeRequest: NetworkRequest {
    
    let httpMethod: HttpMethod = .put
    var dto: Encodable?
    var likes: [String]
    var body: Data? {
        return likesToString().data(using: .utf8)
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    init(dto: Encodable? = nil, likes: [String]) {
        self.dto = dto
        self.likes = likes
    }
    
    private func likesToString() -> String {
        var likeString = "likes="
        if likes.isEmpty {
            likeString = ""
        } else {
            for (index, like) in likes.enumerated() {
                likeString += like
                if index != likes.count - 1 {
                    likeString += "&likes="
                }
            }
        }
        return likeString
    }
}
