//
//  NFTDetails.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 20.08.2024.
//
import Foundation

struct NftDetails: Decodable {
    let id: String
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
}
