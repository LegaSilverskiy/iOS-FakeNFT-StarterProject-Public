import UIKit

final class CartViewController: UIViewController {
    
    private let presenter: CartPresenter
    
    init(servicesAssembly: ServicesAssembly) {
        self.presenter = CartPresenter(servicesAssembly: servicesAssembly)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
    }
}
