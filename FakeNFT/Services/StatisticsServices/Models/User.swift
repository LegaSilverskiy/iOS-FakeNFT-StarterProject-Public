//
//  User.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 13.08.2024.
//
import Foundation

struct User: Decodable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
