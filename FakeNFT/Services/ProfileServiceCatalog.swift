//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/26/24.
//

import Foundation

typealias ProfileCompl = (Result<ProfileForCatalog, Error>) -> Void

final class ProfileServiceCatalog {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadLikes(completion: @escaping ProfileCompl) {
        let request = ProfileRequestCatalog()
        networkClient.send(request: request, type: ProfileForCatalog.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func setLike(id: String, likes: [String], completion: @escaping ProfileCompl) {
        let request = LikeRequest(likes: likes)
        networkClient.send(request: request, type: ProfileForCatalog.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
