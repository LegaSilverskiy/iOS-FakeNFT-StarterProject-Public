//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 15.08.2024.
//

import Foundation

struct ProfileRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}
