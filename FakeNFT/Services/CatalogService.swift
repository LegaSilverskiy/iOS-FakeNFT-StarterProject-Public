//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/19/24.
//

import Foundation

typealias CatalogCompletion = (Result<[Catalog], Error>) -> Void

final class CatalogServiceImpl {
    private let networkClient: NetworkClient
    private let storage: CatalogStorage
    
    init(networkClient: NetworkClient, storage: CatalogStorage) {
        self.networkClient = networkClient
        self.storage = storage
    }
    
    func loadCatalogs(completion: @escaping CatalogCompletion) {
        
        let request = CatalogsRequest()
        networkClient.send(request: request, type: [Catalog].self) { [weak storage] result in
            switch result {
            case .success(let catalogs):
                storage?.saveCatalogs(catalogs)
                completion(.success(catalogs))
            case .failure(let error):
                completion(.failure(error))
            }
            print(result)
        }
    }

}
