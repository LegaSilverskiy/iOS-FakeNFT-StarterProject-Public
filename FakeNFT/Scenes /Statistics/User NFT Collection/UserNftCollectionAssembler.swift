//
//  UserNftCollectionAssembler.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 21.08.2024.
//

import UIKit

final class UserNftCollectionAssembler {
    
    private let userNfts: [String]
    private let userNFTService: UserNFTServiceProtocol
    
    init(userNfts: [String], userNFTService: UserNFTServiceProtocol) {
        self.userNfts = userNfts
        self.userNFTService = userNFTService
    }
    
    public func build() -> UIViewController {
        let presenter = UserNFTCollectionPresenter(userNfts: userNfts, userNFTService: userNFTService)
        
        let viewController = UserNFTCollectionVC(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
