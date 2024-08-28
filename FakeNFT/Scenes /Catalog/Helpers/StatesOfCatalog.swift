//
//  States.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/19/24.
//

import Foundation

enum StatesOfCatalog {
    case initial, loading, failed(Error), data([Catalog])
    
}
