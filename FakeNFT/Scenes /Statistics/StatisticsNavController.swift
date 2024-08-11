//
//  StatisticsNavController.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 10.08.2024.
//

import UIKit

final class StatisticsNavController: UINavigationController {
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        
        let statisticsController = StatisticsViewController(
            servicesAssembly: servicesAssembly
        )
        
        super.init(nibName: nil, bundle: nil)
        
        viewControllers.append(statisticsController)
        setNavBarBackwardButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNavBarBackwardButton() {
        
        UIBarButtonItem.appearance().tintColor = .tabBarItemsTintColor
    }
}
