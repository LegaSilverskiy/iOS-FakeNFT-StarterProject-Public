import UIKit

struct AlertButtonAction {
    let buttonTitle: String
    let style: UIAlertAction.Style
    let action: ((UIAlertAction) -> Void)?
}
