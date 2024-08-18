//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 15.08.2024.
//

import UIKit
import Kingfisher

protocol ProfilePresenterProtocol {
    func viewDidLoad()
    var tableNames: [String] { get }
    var profile: Profile? { get set }
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    
    var profile: Profile?
    
    let tableNames = ["Мои NFT", "Избранные NFT", "О разработчике"]
    
    private let profileService: ProfileServiceProtocol
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    func viewDidLoad() {
        
        loadData()
    }
    
    func updateProfileTexts() {
        guard let view = view, let profile else { return }
        
        view.authorName.text = profile.name
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let attributedString = NSAttributedString(
            string: profile.description,
            attributes: [
                .font: UIFont.caption2,
                .paragraphStyle: paragraphStyle
            ])
        view.authorDescription.attributedText = attributedString
        view.adjustTextViewHeight(view.authorDescription)
        
        view.authorLink.text = profile.website
    }
    
    func loadPhoto() {
        guard
            let profileImageURL = profile?.avatar,
            let url = URL(string: profileImageURL),
            let view = view
        else { return }
        
        view.authorImage.kf.setImage(with: url)
        
    }
    
    // MARK: - Private
    
    private func loadData() {
        
        profileService.loadProfile { [weak self] result in
            
            guard let self else { return }
            
            switch result {
            case .success(let profileResult):
                profile = convertIntoModel(model: profileResult)
                updateView()
            case .failure:
                view?.showAlert()
            }
        }
    }
    
    private func convertIntoModel(model: ProfileResult) -> Profile {
        Profile(
            name: model.name,
            description: model.description,
            website: model.website,
            avatar: model.avatar
        )
    }
    
    private func updateView() {
        updateProfileTexts()
        loadPhoto()
        view?.showUIElements()
    }
}
