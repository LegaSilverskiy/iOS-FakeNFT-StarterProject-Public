import Foundation

protocol CartPresenterDelegate: AnyObject {
    func presentBlurredScreen()
}

final class CartPresenter {
    private let servicesAssembly: ServicesAssembly
    weak var delegate: CartPresenterDelegate?
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func didTapButtonInCell() {
        delegate?.presentBlurredScreen()
    }
}
