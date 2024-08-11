import UIKit

final class TabBarController: UITabBarController {
    
    private let servicesAssembly: ServicesAssembly
    
    private let profileTabBarItem = UITabBarItem(
        title: .tabBarItemsProfile,
        image: .tabBarIconsProfile,
        tag: 0
    )
    
    private let catalogTabBarItem = UITabBarItem(
        title: .tabBarItemsCatalog,
        image: .tabBarIconsCatalog,
        tag: 0
    )
    
    private let cartTabBarItem = UITabBarItem(
        title: .tabBarItemsCart,
        image: .tabBarIconsCart,
        tag: 0
    )
    
    private let statisticsTabBarItem = UITabBarItem(
        title: .tabBarItemsStatistics,
        image: .tabBarIconsStatistics,
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
        tabBar.unselectedItemTintColor = .tabBarItemsTintColor
        
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
        
        let navigationCatalogVC = UINavigationController(rootViewController: catalogController)
        let navigationCartVC = UINavigationController(rootViewController: cartController)
        let navigationProfileVC = UINavigationController(rootViewController: profileController)
        let navigationStatisticVC = UINavigationController(rootViewController: statisticsController)
        
        viewControllers = [navigationProfileVC, navigationCatalogVC, navigationCartVC, navigationStatisticVC]
    }
}
