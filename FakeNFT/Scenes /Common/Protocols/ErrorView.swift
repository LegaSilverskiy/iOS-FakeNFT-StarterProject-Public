import UIKit

struct ErrorModel {
    let message: String
    let actionText: String
    let action: () -> Void
    var secondaryActionText: String? = nil
    var secondaryAction: (() -> Void)? = nil
}

protocol ErrorView {
    func showError(_ model: ErrorModel)
}

extension ErrorView where Self: UIViewController {
    
    func showError(_ model: ErrorModel) {
        
        let alert = UIAlertController(
            title: .errorTitle,
            message: model.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: model.actionText, style: UIAlertAction.Style.default) {_ in
            model.action()
        }
        
        alert.addAction(action)
        
        if let secondaryActionText = model.secondaryActionText,
           let secondaryAction = model.secondaryAction  {
            let action = UIAlertAction(title: secondaryActionText, style: UIAlertAction.Style.default) {_ in
                secondaryAction()
            }
            alert.addAction(action)
        }
        
        present(alert, animated: true)
    }
}
