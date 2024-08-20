//
//  MyNftService.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 19.08.2024.
//

import Foundation

typealias NftsCompletion = (Result<NFTModel, Error>) -> Void

protocol NftServiceProtocol {
    func loadNfts(id: String, completion: @escaping NftsCompletion)
}

final class MyNftService: NftServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadNfts(id: String, completion: @escaping NftsCompletion) {

        let request = MyNftRequest(id: id)
        networkClient.send(request: request, type: NFTModel.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
