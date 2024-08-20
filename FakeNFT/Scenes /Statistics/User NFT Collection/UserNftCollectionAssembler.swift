//
//  UserNftCollectionAssembler.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 21.08.2024.
//

import UIKit

final class UserNftCollectionAssembler {
    
    private let userNFTService: UserNFTServiceProtocol
    
    init(userNFTService: UserNFTServiceProtocol) {
        self.userNFTService = userNFTService
    }
    
    public func build() -> UIViewController {
        let presenter = UserNFTCollectionPresenter(userNFTService: userNFTService)
        
        let viewController = UserNFTCollectionVC(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
