//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 23.08.2024.
//
import Foundation

protocol ProfileServiceProtocol {
    func loadProfile(completion: @escaping ProfileCompletion)
}

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

final class ProfileService: ProfileServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadProfile(completion: @escaping ProfileCompletion) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) {result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
