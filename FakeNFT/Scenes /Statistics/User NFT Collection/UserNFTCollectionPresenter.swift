//
//  UserNFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 21.08.2024.
//
import Foundation

protocol UserNFTCollectionPresenterProtocol {
    
}

final class UserNFTCollectionPresenter: UserNFTCollectionPresenterProtocol {

    // MARK: - Public Properties
    weak var view: UserNFTCollectionVC?
    
    // MARK: - Private Properties
    private let userNfts: [String]
    private let userNFTService: UserNFTServiceProtocol
    
    // MARK: - Initializers
    init(userNfts: [String], userNFTService: UserNFTServiceProtocol) {
        self.userNfts = userNfts
        self.userNFTService = userNFTService
    }
    
    // MARK: - Public Methods
    func showStub() -> Bool {
        userNfts.isEmpty
    }
    
    func getItemsCount() -> Int {
        userNfts.count
    }
    
    // MARK: - Private Methods
    
}

// MARK: - TrackersCVCellDelegate
extension UserNFTCollectionPresenter: UserNFTCollectionCellDelegate {

}
