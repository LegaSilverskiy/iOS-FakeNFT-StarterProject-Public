import UIKit

enum SortOption {
    case name
    case rating
    case price
}

struct AlertModel {
    let title: String?
    let message: String?
}

struct AlertButtonAction {
    let buttonTitle: String
    let style: UIAlertAction.Style
    let action: ((UIAlertAction) -> Void)?
}


