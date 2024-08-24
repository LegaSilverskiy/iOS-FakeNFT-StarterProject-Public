import UIKit

extension UIAlertController {
    
    func createAlert(for model: AlertModel, action: [AlertButtonAction], style: UIAlertController.Style) -> UIAlertController {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: style
        )
        
        action.forEach { button in
            let actionButton = UIAlertAction(
                title: button.buttonTitle,
                style: button.style,
                handler: button.action
            )
            alert.addAction(
                actionButton
            )
        }
        
        return alert
    }
}
