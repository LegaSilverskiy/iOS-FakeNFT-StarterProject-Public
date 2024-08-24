//
//  FavouritesPresenter.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 22.08.2024.
//

import Foundation
import ProgressHUD

protocol FavouritesPresenterProtocol {
    func viewDidLoad()
    func didTapExit()
    func didTapLike(id: String)
    var favouriteNfts: [NftResult] { get }
}

final class FavouritesPresenter: FavouritesPresenterProtocol {

    weak var view: FavouritesViewProtocol?

    weak var delegate: SendInfoDelegate?

    var favouriteNfts: [NftResult] = []

    private var profile: Profile

    private let nftService: NftServiceProtocol

    private let favouritesService: FavouritesServiceProtocol

    init(
        nftService: NftServiceProtocol,
        favouritesService: FavouritesServiceProtocol,
        profile: Profile
    ) {
        self.profile = profile
        self.nftService = nftService
        self.favouritesService = favouritesService
    }

    func viewDidLoad() {
        loadNfts()
    }

    func didTapExit() {
        view?.showUIElements()
        delegate?.loadPresenter()
    }

    private func loadNfts() {

        let group = DispatchGroup()

        profile.likes.forEach { nft in
            group.enter()
            nftService.loadNfts(id: nft) { [weak self] result in

                defer { group.leave() }

                guard let self else { return }

                switch result {
                case .success(let nft):
                    self.favouriteNfts.append(NftResult(nft: nft))
                case .failure(let error):
                    print(error.localizedDescription)
                    // TODO: - Алерт об ошибке
                }
            }
        }

        group.notify(queue: .main) { [weak self] in

            guard let self else { return }

            self.view?.showUIElements()

            if self.favouriteNfts.isEmpty {
                view?.showEmptyFavouriteNfts()
            }
        }
    }

    private func updateData(profile: Profile) {

        view?.showLoading()

        favouritesService.updateProfile(profile: profile) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                view?.showUIElements()

            case .failure:
                print("Update failed")
                view?.showUIElements()
                // TODO: - Алерт об ошибке
            }
        }
    }

    func didTapLike(id: String) {

        profile.likes.removeAll { nftId in
            nftId == id
        }
        favouriteNfts.removeAll { nft in
            nft.id == id
        }

        updateData(profile: profile)

        if favouriteNfts.isEmpty {
            view?.showEmptyFavouriteNfts()
        }
    }
}
