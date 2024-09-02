//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 15.08.2024.
//

import Foundation

typealias ProfileCompletion = (Result<ProfileResult, Error>) -> Void

protocol ProfileServiceProtocol {
    func loadProfile(completion: @escaping ProfileCompletion)
}

final class ProfileService: ProfileServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile(completion: @escaping ProfileCompletion) {

        let request = ProfileRequest()
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
