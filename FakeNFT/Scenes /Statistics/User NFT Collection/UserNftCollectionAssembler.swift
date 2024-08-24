//
//  UserNftCollectionAssembler.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 21.08.2024.
//

import UIKit

final class UserNftCollectionAssembler {

    private let userNfts: [String]
    private let servisesAssembly: ServicesAssembly

    init(userNfts: [String], servisesAssembly: ServicesAssembly) {
        self.userNfts = userNfts
        self.servisesAssembly = servisesAssembly
    }

    public func build() -> UIViewController {
        let presenter = UserNFTCollectionPresenter(userNfts: userNfts, servisesAssembly: servisesAssembly)

        let viewController = UserNFTCollectionVC(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
