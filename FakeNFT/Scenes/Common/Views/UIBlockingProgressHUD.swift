//
//  UIBlockingProgressHUD.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 15.08.2024.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {

    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }

    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animationType = .ballVerticalBounce
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
