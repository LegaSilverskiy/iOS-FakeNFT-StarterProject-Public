import UIKit

extension UIAlertController {
    
    func showSortActionSheet(for model: AlertModel, action: [AlertButtonAction]) -> UIAlertController {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .actionSheet)
        
        action.forEach { button in
            let actionButton = UIAlertAction(title: button.buttonTitle, style: button.style, handler: button.action)
            alert.addAction(actionButton)
        }
        
        return alert
    }
}
