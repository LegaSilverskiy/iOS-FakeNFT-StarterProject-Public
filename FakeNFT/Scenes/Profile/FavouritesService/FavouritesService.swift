//
//  FavouritesService.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 22.08.2024.
//

import Foundation

typealias FavouritesCompletion = (Result<ProfileResult, Error>) -> Void

protocol FavouritesServiceProtocol: AnyObject {
    func updateProfile(profile: Profile, completion: @escaping FavouritesCompletion)
}

final class FavouritesService: FavouritesServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func updateProfile(profile: Profile, completion: @escaping FavouritesCompletion) {

        let request = FavouritesRequest(profile: profile)
        networkClient.send(request: request, type: ProfileResult.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
