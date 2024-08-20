//
//  UserCardAssembler.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 20.08.2024.
//

import UIKit

final class UserCardAssembler {
    
    private let userInfo: User
    private let userNFTService: UserNFTServiceProtocol
    
    init(userInfo: User, userNFTService: UserNFTServiceProtocol) {
        self.userInfo = userInfo
        self.userNFTService = userNFTService
    }
    
    public func build() -> UIViewController {
        let presenter = UserCardPresenter(userInfo: userInfo, userNFTService: userNFTService)
        
        let viewController = UserCardViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
