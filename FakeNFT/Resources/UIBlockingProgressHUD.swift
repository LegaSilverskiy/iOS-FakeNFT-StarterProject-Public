import Foundation
import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorAnimation = .tabBarItemsTintColor
        ProgressHUD.colorHUD = .textOnPrimary
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
