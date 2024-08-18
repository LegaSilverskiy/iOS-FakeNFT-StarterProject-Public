import UIKit

extension CartViewController: CartTableViewCellDelegate {
    func didTapButton(in cell: CartTableViewCell, at indexPath: IndexPath) {
        presenter.didTapButtonInCell(at: indexPath)
    }
}
