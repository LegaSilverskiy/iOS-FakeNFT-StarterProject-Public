//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 15.08.2024.
//

import UIKit

final class ProfilePresenter {
    
    weak var view: ProfileViewController?
    
    let servicesAssembly: ServicesAssembly
    
    var _profileDescription = ["Joaquin Phoenix", "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.", "Joaquin Phoenix.com"]
    
    let tableNames = ["Мои NFT", "Избранные NFT", "О разработчике"]
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func openEditScreen() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.delegate = view
        let editNavController = UINavigationController(rootViewController: editProfileViewController)
        view?.present(editNavController, animated: true)
    }
    
    func updateProfileTexts(with text: [String]) {
        guard let view = view else { return }
        
        view.authorName.text = text[0]
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let attributedString = NSAttributedString(
            string: text[1],
            attributes: [
                .font: UIFont.caption2,
                .paragraphStyle: paragraphStyle
            ])
        view.authorDescription.attributedText = attributedString
        adjustTextViewHeight(view.authorDescription)
        
        view.authorLink.text = text[2]
        
        view.profileDescription = text
    }
    
    func adjustTextViewHeight(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
        var estimatedSize = textView.sizeThatFits(size)
        
        if estimatedSize.width == 0 {
            estimatedSize.height = 0
        }
        
        var frame = textView.frame
        frame.size.height = estimatedSize.height
        textView.frame = frame
        
        // Обновление ограничений
        view?.updateConstraintsForTextView(textView, estimatedSize: estimatedSize)
    }
}
