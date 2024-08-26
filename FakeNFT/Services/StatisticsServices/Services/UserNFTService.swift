//
//  UserNFTService.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 20.08.2024.
//
import Foundation

protocol UserNFTServiceProtocol {
    func loadNftDetails(id: String,
                        completion: @escaping NFTDetailsCompletion
    )
}

typealias NFTDetailsCompletion = (Result<NftDetails, Error>) -> Void

final class UserNFTService: UserNFTServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadNftDetails(id: String, completion: @escaping NFTDetailsCompletion) {
        let request = NFTDetailsRequest(id: id)
        networkClient.send(request: request, type: NftDetails.self) {result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
