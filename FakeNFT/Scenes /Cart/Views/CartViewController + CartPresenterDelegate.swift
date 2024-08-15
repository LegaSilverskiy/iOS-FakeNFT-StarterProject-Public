import UIKit

extension CartViewController: CartPresenterDelegate {
    
    func presentBlurredScreen() {
        let blurredVC = CartDeleteViewController()
        blurredVC.modalPresentationStyle = .overFullScreen
        blurredVC.modalTransitionStyle = .crossDissolve
        present(blurredVC, animated: true, completion: nil)
    }
}
