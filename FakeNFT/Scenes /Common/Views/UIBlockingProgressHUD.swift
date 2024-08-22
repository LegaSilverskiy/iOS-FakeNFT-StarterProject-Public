//
//  UIBlockingProgressHUD.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/22/24.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    static func like() {
        window?.isUserInteractionEnabled = false
    }
    
    static func dislike() {
        window?.isUserInteractionEnabled = false
    }
}
