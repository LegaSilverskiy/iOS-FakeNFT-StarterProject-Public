//
//  UserCardPresenter.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 20.08.2024.
//

import Foundation

protocol UserCardPresenterProtocol {
    func showNFTsButtonPressed()
    func updateAvatar()
    func getUserName() -> String
    func getUserDescription() -> String
    func getNFTcount() -> Int
}

final class UserCardPresenter: UserCardPresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: UserCardViewProtocol?
    
    // MARK: - Private Properties
    private var userInfo: User
    private let userNFTService: UserNFTServiceProtocol
    
    // MARK: - Initializers
    init(userInfo: User, userNFTService: UserNFTServiceProtocol) {
        
        self.userInfo = userInfo
        self.userNFTService = userNFTService
    }
    
    // MARK: - Public Methods
    
    func updateAvatar() {
        if let url = URL(string: userInfo.avatar) {
            view?.updateUserImage(with: url)
        }
    }
    
    func getUserName() -> String {
        userInfo.name
    }
    
    func getUserDescription() -> String {
        userInfo.description
    }
    
    func getNFTcount() -> Int {
        userInfo.nfts.count
    }
    
    func showNFTsButtonPressed() {
        view?.switchToUserNFTCollectionVC(userNfts: userInfo.nfts, userNFTService: userNFTService)
    }
    
    // MARK: - Private Methods
    
}
