//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 14.08.2024.
//

import UIKit
import Kingfisher

struct AlertModel {
    let title: String
    let message: String?
    let placeholder: String?
    let okTitle: String
    let cancelTitle: String
}

protocol EditProfilePresenterProtocol {
    func didTapExit()
    func viewDidLoad()
    func updateEditedText(at index: Int, with text: String)
    func updatePhoto() -> AlertModel
    func initializeEditedText(with data: [String]) 
    func loadPhoto(with urlString: String?)
    var editedText: [String] { get }
    var tableHeaders: [String] { get }
    var profile: Profile { get set }
}

final class EditProfilePresenter: EditProfilePresenterProtocol {
    
    weak var view: EditProfileViewProtocol?
    
    weak var delegate: SendTextDelegate?
    
    var editedText: [String] {
        _editedText
    }
    
    var tableHeaders = ["Имя", "Описание", "Сайт"]
    
    var profile: Profile
    
    private let profileService: EditProfileServiceProtocol
    
    private var _editedText = [String]()
    
    init(profileService: EditProfileServiceProtocol, profile: Profile) {
        self.profileService = profileService
        self.profile = profile
    }
    
    func viewDidLoad() {
        loadPhoto(with: profile.avatar)
    }
    
    func initializeEditedText(with data: [String]) {
        _editedText = data
    }
    
    func updateEditedText(at index: Int, with text: String) {
        _editedText[index] = text
    }
    
    func updatePhoto() -> AlertModel {
        AlertModel(
            title: "Введите URL нового фото",
            message: nil,
            placeholder: "Вставьте ссылку",
            okTitle: "Ок",
            cancelTitle: "Отмена"
        )
    }
    
    func loadPhoto(with urlString: String?) {
        guard
            let urlString,
            let url = URL(string: urlString),
            let view
        else { return }
        
        view.authorImage.kf.setImage(with: url)
        
    }
    
    func didTapExit() {
        updateAndNotify(text: editedText) { [weak self] in
            self?.delegate?.loadPresenter()
        }
    }
    
    // MARK: - Private
    
    private func convertStringToProfile(text: [String]) -> Profile {
        Profile(
            name: text[0],
            description: text[1],
            website: text[2],
            avatar: text[3]
        )
    }
    
    private func updateAndNotify(text: [String], completion: @escaping () -> Void) {
        let updatedProfile = convertStringToProfile(text: text)
        
        updateData(profile: updatedProfile) {
            completion()
        }
    }
    
    private func updateData(profile: Profile, completion: @escaping () -> Void) {
        profileService.updateProfile(profile: profile) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profileResult):
                self.profile = Profile(
                    name: profileResult.name,
                    description: profileResult.description,
                    website: profileResult.website,
                    avatar: profileResult.avatar
                )
                completion()
                
            case .failure:
                print("Update failed")
                completion()
            }
        }
    }
    
}
