//
//  StatesOfNft.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/23/24.
//

import Foundation

enum StatesOfCurrentCollection{
    case initial, loading, failed(Error), data([Catalog])
    
}
