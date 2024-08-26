//
//  UserSitePresenter.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 25.08.2024.
//
import Foundation

protocol UserSitePresenterProtocol {
    func viewDidLoad()
    func didUpdateProgressValue(_ estimatedProgress: Double)
}

final class UserSitePresenter: UserSitePresenterProtocol {

    // MARK: - Public Properties
    weak var view: UserSiteViewProtocol?

    // MARK: - Private Properties
    private let userSiteUrl: String

    // MARK: - Initializers
    init(userSiteUrl: String) {
        self.userSiteUrl = userSiteUrl
    }

    // MARK: - Public Methods
    func viewDidLoad() {
        didUpdateProgressValue(0)
        loadUserSite(with: userSiteUrl)
    }

    func didUpdateProgressValue(_ estimatedProgress: Double) {
        let newProgressValue = Float(estimatedProgress)
        view?.setProgressValue(newProgressValue)

        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }

    // MARK: - Private Methods
    private func loadUserSite(with url: String) {
        if let url = URL(string: url) {
            view?.loadSite(url: url)
        }
    }
}
