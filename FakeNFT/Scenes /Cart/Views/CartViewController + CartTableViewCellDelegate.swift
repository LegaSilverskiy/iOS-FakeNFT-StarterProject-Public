import UIKit

extension CartViewController: CartTableViewCellDelegate {
    func didTapButton(in cell: CartTableViewCell, at indexPath: IndexPath, with image: String) {
        presenter.didTapButtonInCell(at: indexPath, with: image)
    }
}
