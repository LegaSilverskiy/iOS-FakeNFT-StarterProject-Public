//
//  Order.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/26/24.
//

import Foundation

struct Order: Codable {
    let nfts: [String]
    let id: String
}
