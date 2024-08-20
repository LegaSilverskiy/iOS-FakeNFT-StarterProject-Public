//
//  SortingOrder.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 13.08.2024.
//

import Foundation

enum SortingOrder: String {

    case asc
    case desc
    
    func asParameter() -> String {
        
        return ("order=\(self.rawValue)")
    }
}
