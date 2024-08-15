import UIKit

extension CartViewController: CartTableViewCellDelegate {
    func didTapButton(in cell: CartTableViewCell) {
        presenter.didTapButtonInCell()
    }
}
