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
    func userSiteButtonPressed()
}

final class UserCardPresenter: UserCardPresenterProtocol {

    // MARK: - Public Properties
    weak var view: UserCardViewProtocol?

    // MARK: - Private Properties
    private let userInfo: User
    private let servisesAssembly: ServicesAssembly
    private let userNFTService: UserNFTServiceProtocol

    // MARK: - Initializers
    init(userInfo: User, servisesAssembly: ServicesAssembly) {
        self.userInfo = userInfo
        self.servisesAssembly = servisesAssembly
        self.userNFTService = servisesAssembly.userNFTService
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
        view?.switchToUserNFTCollectionVC(userNfts: userInfo.nfts, servisesAssembly: servisesAssembly)
    }

    func userSiteButtonPressed() {
        view?.showUserSite(url: userInfo.website)
    }
}
