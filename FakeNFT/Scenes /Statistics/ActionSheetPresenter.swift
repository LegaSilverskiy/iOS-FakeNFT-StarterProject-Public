//
//  ActionSheetPresenter.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 10.08.2024.
//
import UIKit

protocol ActionSheetPresenterDelegate: AnyObject {
    func performSortig(with option: SortingOptions)
}

final class ActionSheetPresenter {
    
    static func show(actionSheet name: String,
                     with options: [SortingOptions],
                     on screen: UIViewController,
                     delegate: ActionSheetPresenterDelegate
    ) {
        let alert = UIAlertController(title: nil,
                                      message: name,
                                      preferredStyle: .actionSheet
        )
        
        for option in options {
            alert.addAction(UIAlertAction(title: option.localizedTitle(),
                                          style: .default) {_ in
                delegate.performSortig(with: option)
            })
        }
        
        alert.addAction(UIAlertAction(title: .buttonsCancel,
                                      style: .cancel) {_ in
            alert.dismiss(animated: true)
        })
        
        screen.present(alert, animated: true, completion: nil)
    }
}
