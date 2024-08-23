//
//  UserCardAssembler.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 20.08.2024.
//

import UIKit

final class UserCardAssembler {
    
    private let userInfo: User
    private let servisesAssembly: ServicesAssembly
    
    init(userInfo: User, servisesAssembly: ServicesAssembly) {
        self.userInfo = userInfo
        self.servisesAssembly = servisesAssembly
    }
    
    public func build() -> UIViewController {
        let presenter = UserCardPresenter(userInfo: userInfo, servisesAssembly: servisesAssembly)
        
        let viewController = UserCardViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
