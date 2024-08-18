import UIKit

extension CartViewController: CartPresenterDelegate {
 func presentBlurredScreen(with indexPath: IndexPath) {
        let blurredVC = CartDeleteViewController()
        blurredVC.delegate = self
        blurredVC.indexPath = indexPath
        blurredVC.modalPresentationStyle = .overFullScreen
        blurredVC.modalTransitionStyle = .crossDissolve
        present(blurredVC, animated: true, completion: nil)
    }
    
    func deleteFromCart(at indexPath: IndexPath) {
        presenter.deleteFromCart(at: indexPath)
    }
}
