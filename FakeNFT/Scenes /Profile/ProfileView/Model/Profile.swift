//
//  Profile.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 15.08.2024.
//

import Foundation

struct ProfileResult: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    var nfts: [String]
    var likes: [String]
}

struct Profile {
    var name: String
    var description: String
    var website: String
    var avatar: String
    var nfts: [String]
    var likes: [String]
}
