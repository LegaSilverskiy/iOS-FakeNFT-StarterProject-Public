//
//  UsersStorage.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 14.08.2024.
//
import Foundation

final class UsersStorage {
    private var storage: [User] = []
    
    private let syncQueue = DispatchQueue(label: "sync-users-queue")
    
    func saveUsers(_ newUsers: [User]) {
        syncQueue.async { [weak self] in
            self?.storage.append(contentsOf: newUsers)
        }
    }
    
    func clearData() {
        syncQueue.async { [weak self] in
            self?.storage.removeAll()
        }
    }
    
    func getUsers() -> [User] {
        syncQueue.sync {
            storage
        }
    }
}
