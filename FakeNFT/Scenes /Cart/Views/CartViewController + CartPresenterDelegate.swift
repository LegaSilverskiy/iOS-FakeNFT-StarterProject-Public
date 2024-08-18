import UIKit

extension CartViewController: CartPresenterDelegate {
    func deleteFromCart(at indexPath: IndexPath) {
        presenter.deleteFromCart(at: indexPath)
    }
    
    func presentBlurredScreen(with indexPath: IndexPath, imageURL: String) {
        let blurredVC = CartDeleteViewController()
        blurredVC.delegate = self
        blurredVC.indexPath = indexPath
        blurredVC.imageURL = imageURL
        blurredVC.modalPresentationStyle = .overFullScreen
        blurredVC.modalTransitionStyle = .crossDissolve
        present(blurredVC, animated: true, completion: nil)
    }
}
