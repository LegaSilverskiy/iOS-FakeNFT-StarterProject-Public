//
//  SortingOptions.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 10.08.2024.
//

import Foundation

enum SortingOptions {

    case name
    case rating
    
    func localizedTitle() -> String {
        
        switch self {
            
        case .name:
            return .sortingOptionsName
        case .rating:
            return .sortingOptionsRating
        }
    }
}
