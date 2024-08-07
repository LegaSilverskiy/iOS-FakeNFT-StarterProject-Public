import UIKit

final class TabBarController: UITabBarController {

    private let servicesAssembly: ServicesAssembly

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("tabBarController.tab.profile", comment: ""),
        image: UIImage(named: "tabBar.profile"),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("tabBarController.tab.catalog", comment: ""),
        image: UIImage(named: "tabBar.catalog"),
        tag: 0
    )

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("tabBarController.tab.cart", comment: ""),
        image: UIImage(named: "tabBar.cart"),
        tag: 0
    )

    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("tabBarController.tab.statistics", comment: ""),
        image: UIImage(named: "tabBar.statistics"),
        tag: 0
    )
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setTabs()
    }
    
    private func setTabs() {
        
        let profileController = ProfileViewController(
            servicesAssembly: servicesAssembly
        )
        profileController.tabBarItem = profileTabBarItem
        
        let catalogController = CatalogViewController(
            servicesAssembly: servicesAssembly
        )
        catalogController.tabBarItem = catalogTabBarItem
        
        let cartController = CartViewController(
            servicesAssembly: servicesAssembly
        )
        cartController.tabBarItem = cartTabBarItem
        
        let statisticsController = StatisticsViewController(
            servicesAssembly: servicesAssembly
        )
        statisticsController.tabBarItem = statisticsTabBarItem

        viewControllers = [profileController, catalogController, cartController, statisticsController]
    }
}
