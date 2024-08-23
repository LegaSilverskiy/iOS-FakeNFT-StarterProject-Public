//
//  NftModel.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 19.08.2024.
//

import UIKit

struct NFTModel: Decodable {
    let name: String
    let images: [String]
    let rating: Int
    let price: Double
    let id: String
    let author: String
}

struct NftResult {
    let name: String
    let image: String
    let rating: Int
    let price: Double
    let author: String
    let id: String
    let priceStr: String
    
    init(nft: NFTModel) {
        self.name = nft.name
        self.image = nft.images.first ?? ""
        self.rating = nft.rating
        self.price = nft.price
        self.author = nft.author
        self.id = nft.id

        self.priceStr = "\(price) ETH"
    }
}
