//
//  FavoritesService.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 23.08.2024.
//
import Foundation

protocol FavoritesServiceProtocol {
    func sendFavoritesRequest(httpMethod: HttpMethod, favoriteNfts: [String]?, completion: @escaping FavoritesCompletion)
}

typealias FavoritesCompletion = (Result<Favorites, Error>) -> Void

final class FavoritesService: FavoritesServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func sendFavoritesRequest(httpMethod: HttpMethod, favoriteNfts: [String]?, completion: @escaping FavoritesCompletion) {
        let request = FavoritesRequest(httpMethod: httpMethod, favoriteNfts: favoriteNfts)
        networkClient.send(request: request, type: Favorites.self) {result in
            switch result {
            case .success(let favorites):
                completion(.success(favorites))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
