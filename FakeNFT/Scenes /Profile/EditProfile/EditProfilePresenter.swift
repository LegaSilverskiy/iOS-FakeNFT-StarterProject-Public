//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 14.08.2024.
//

import UIKit
import Kingfisher

protocol EditProfilePresenterProtocol {
    func updateAndNotify(text: [String], completion: @escaping () -> Void)
    func loadPhoto(with urlString: String?)
    func updatePhoto() -> UIAlertController
    var editedText: [String] { get set }
    var tableHeaders: [String] { get }
    var profile: Profile { get set }
}

final class EditProfilePresenter: EditProfilePresenterProtocol {
    
    weak var view: EditProfileViewProtocol?
    
    var editedText = [String]()
    
    var tableHeaders = ["Имя", "Описание", "Сайт"]
    
    var profile: Profile
    
    private var profileService: EditProfileServiceProtocol
    
    init(profileService: EditProfileServiceProtocol, profile: Profile) {
        self.profileService = profileService
        self.profile = profile
    }
    
    func updateAndNotify(text: [String], completion: @escaping () -> Void) {
        let updatedProfile = convertStringToProfile(text: text)
        
        let group = DispatchGroup()
        
        group.enter()
        
        updateData(profile: updatedProfile, completion: {
            group.leave()
        })
        
        group.notify(queue: .main) {
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
    
    func updatePhoto() -> UIAlertController {
        let alertController = UIAlertController(title: "Введите URL нового фото", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Вставьте ссылку"
        }
        let okAction = UIAlertAction(title: "Ок", style: .default) { _ in
            guard let text = alertController.textFields?.first?.text else {
                return
            }
            self.loadPhoto(with: text)
            self.editedText.insert(text, at: 3)
        }
        let dismissAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        alertController.addAction(dismissAction)
        return alertController
    }
    
    func loadPhoto(with urlString: String?) {
        guard
            let urlString,
            let url = URL(string: urlString),
            let view
        else { return }
        
        view.authorImage.kf.setImage(with: url)
        
    }
    
    private func convertStringToProfile(text: [String]) -> Profile {
        Profile(
            name: text[0],
            description: text[1],
            website: text[2],
            avatar: text[3]
        )
    }
}
