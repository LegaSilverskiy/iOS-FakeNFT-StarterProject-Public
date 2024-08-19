//
//  CatalogStorage.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/19/24.
//

import Foundation

final class CatalogStorage {
    
    private var storage: [Catalog] = []
    
    private let syncQueue = DispatchQueue(label: "sync-catalog-queue")
    
    func saveCatalogs(_ newCatalogs: [Catalog]) {
        syncQueue.async { [weak self] in
            self?.storage.append(contentsOf: newCatalogs)
        }
    }
    
    func clearData() {
        syncQueue.async { [weak self] in
            self?.storage.removeAll()
        }
    }
    
    func getCatalogs() -> [Catalog] {
        syncQueue.sync {
            storage
        }
    }
}
