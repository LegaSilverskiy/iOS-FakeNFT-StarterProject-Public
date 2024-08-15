//
//  ProfileAssembly.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 15.08.2024.
//

import UIKit

public final class ProfileAssembly {
    
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    public func build() -> UIViewController {
        let presenter = ProfilePresenter(
            profileService: servicesAssembler.profileService
        )
        let viewController = ProfileViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
