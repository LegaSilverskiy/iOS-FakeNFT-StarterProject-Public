//
//  UsersService.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 13.08.2024.
//
import Foundation

typealias UsersCompletion = (Result<[User], Error>) -> Void

final class UsersService {
    
    private let networkClient: NetworkClient
    private let storage: UsersStorage
    
    init(networkClient: NetworkClient, storage: UsersStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadUsers(page: Int,
                   pageSize: Int,
                   reloadMode: Bool,
                   completion: @escaping UsersCompletion
    ) {
        
        if page == 1 && !reloadMode {
            let storedUsers = storage.getUsers()
            if storedUsers.count > 0 {
                completion(.success(storedUsers))
                return
            }
        } else if reloadMode {
            storage.clearData()
        }
        
        let request = UsersRequest(page: page,
                                   size: pageSize
        )
        
        networkClient.send(request: request, type: [User].self) { [weak storage] result in
            switch result {
            case .success(let users):
                storage?.saveUsers(users)
                completion(.success(storage?.getUsers() ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
