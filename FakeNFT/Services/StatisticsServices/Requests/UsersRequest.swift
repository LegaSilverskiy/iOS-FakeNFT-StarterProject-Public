//
//  UsersRequest.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 13.08.2024.
//
import Foundation

struct UsersRequest: NetworkRequest {

    let page: Int
    let size: Int

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users"
            + "?page=\(String(page))&size=\(String(size))"
        )
    }
}
