//
//  EditProfileService.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 15.08.2024.
//

import Foundation

typealias EditProfileCompletion = (Result<ProfileResult, Error>) -> Void

protocol EditProfileServiceProtocol: AnyObject {
    func updateProfile(profile: Profile, completion: @escaping EditProfileCompletion)
}

final class EditProfileService: EditProfileServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func updateProfile(profile: Profile, completion: @escaping EditProfileCompletion) {

        let request = EditProfileRequest(profile: profile)
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
