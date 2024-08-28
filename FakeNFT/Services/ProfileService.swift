//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/26/24.
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

final class ProfileService  {
    
    private let networkClient: NetworkClient
    private let storage: NftStorage
    
    init(networkClient: NetworkClient, storage: NftStorage) {
        self.networkClient = networkClient
        self.storage = storage
        loadProfile { _ in }
    }
    
    func loadProfile(completion: @escaping ProfileCompletion) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                profile.likes.forEach {
                    storage?.saveLike($0)
                }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func likeState(for id: String) -> Bool {
        storage.getLike(with: id) != nil
    }
}
