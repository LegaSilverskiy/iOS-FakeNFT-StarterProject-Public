//
//  CatalogMainScreenModel.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/13/24.
//

import Foundation

struct Catalog: Codable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
