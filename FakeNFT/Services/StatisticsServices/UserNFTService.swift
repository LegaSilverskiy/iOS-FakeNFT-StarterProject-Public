//
//  UserNFTService.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 20.08.2024.
//
import Foundation

protocol UserNFTServiceProtocol {
    func loadNfts(nftList: [String],
                  completion: @escaping UsersNFTsCompletion
    )
//    func loadUsers(itemsLoaded: Int,
//                   pageSize: Int,
//                   completion: @escaping UsersCompletion
//    )
}

typealias UsersNFTsCompletion = (Result<[NftDetails], Error>) -> Void

final class UserNFTService: UserNFTServiceProtocol {

    private let networkClient: NetworkClient
    private let storage: UsersStorage
    
    init(networkClient: NetworkClient, storage: UsersStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadNfts(nftList: [String], completion: @escaping UsersNFTsCompletion) {
        
    }
//
//    func loadUsers(itemsLoaded: Int,
//                   pageSize: Int,
//                   completion: @escaping UsersNFTsCompletion
//    ) {
//        
//        let storedUsers = storage.getUsers()
//        
//        if storedUsers.count > itemsLoaded {
//            completion(.success(storedUsers))
//        }
//        
//        let pageForLoad = storedUsers.count / max(pageSize, 1) + 1
//        
//        let request = UsersRequest(page: pageForLoad,
//                                   size: max(pageSize, 1)
//        )
//        
//        networkClient.send(request: request, type: [User].self) { [weak storage] result in
//            switch result {
//            case .success(let users):
//                storage?.saveUsers(users)
//                completion(.success(users))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
}
