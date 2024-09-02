//
//  UserSiteAssembler.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 25.08.2024.
//

import UIKit

final class UserSiteAssembler {

    private let userSiteUrl: String

    init(userSiteUrl: String) {
        self.userSiteUrl = userSiteUrl
    }
    public func build() -> UIViewController {
        let presenter = UserSitePresenter(userSiteUrl: userSiteUrl)

        let viewController = UserSiteViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
