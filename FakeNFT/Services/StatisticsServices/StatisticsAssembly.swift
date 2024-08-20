//
//  StatisticsAssembly.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 19.08.2024.
//
import UIKit

final class StatisticsAssembly {
    private let servicesAssembler: ServicesAssembly
    
    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }
    
    public func build() -> UIViewController {
        let presenter = StatisticsPresenter(
            usersService: servicesAssembler.usersService
        )
        let viewController = StatisticsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
