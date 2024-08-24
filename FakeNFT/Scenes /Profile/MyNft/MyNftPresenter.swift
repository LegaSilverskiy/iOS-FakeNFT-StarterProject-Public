//
//  MyNftPresenter.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 19.08.2024.
//

import ProgressHUD
import UIKit

protocol MyNftPresenterProtocol {
    func viewDidLoad()
    func sortNfts(by: SortKeys)
    func didTapLike(needToAdd: Bool, id: String)
    func didTapExit()
    var nfts: [NftResult] { get set }
}

enum SortKeys: String, CaseIterable {
    case name = "По имени"
    case price = "По цене"
    case rating = "По рейтингу"
}

final class MyNftPresenter: MyNftPresenterProtocol {

    weak var view: MyNftViewProtocol?

    weak var delegate: SendInfoDelegate?

    var nfts: [NftResult] = []

    private var profile: Profile

    private let nftService: NftServiceProtocol
    private let favService: FavouritesServiceProtocol

    init(nftService: NftServiceProtocol, favService: FavouritesServiceProtocol, profile: Profile) {
        self.profile = profile
        self.nftService = nftService
        self.favService = favService
    }

    func viewDidLoad() {
        loadNfts()
    }

    func sortNfts(by option: SortKeys) {
        switch option {
        case .price:
            nfts = nfts.sorted(by: {
                $0.price < $1.price
            })
        case .rating:
            nfts = nfts.sorted(by: {
                $0.rating < $1.rating
            })
        case .name:
            nfts = nfts.sorted(by: {
                $0.name < $1.name
            })
        }
        view?.showUIElements()
    }

    func setLikes() {
        for index in nfts.indices {
            let nft = nfts[index]
            nfts[index].isLiked = profile.likes.contains(nft.id)
        }
    }

    func didTapLike(needToAdd: Bool, id: String) {

        if needToAdd {
            profile.likes.append(id)

        } else {
            profile.likes.removeAll {
                $0 == id
            }
        }

        setLikes()

        updateData(profile: profile)
    }

    func didTapExit() {
        view?.showUIElements()
        delegate?.loadPresenter()
    }

    // MARK: - Private

    private func loadNfts() {

        nfts.removeAll()

        let group = DispatchGroup()

        profile.nfts.forEach { nft in
            group.enter()
            nftService.loadNfts(id: nft) { [weak self] result in

                defer { group.leave() }

                guard let self else { return }

                switch result {
                case .success(let nft):
                    self.nfts.append(NftResult(nft: nft))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }

        group.notify(queue: .main) { [weak self] in

            guard let self else { return }

            if let savedSortKey = UserDefaults.standard.string(forKey: "selectedSortKey"),
               let sortOption = SortKeys(rawValue: savedSortKey) {
                self.sortNfts(by: sortOption)
            } else {
                self.sortNfts(by: .name)
            }
            self.view?.showUIElements()

            setLikes()

            if self.nfts.isEmpty {
                view?.showEmptyNfts()
            }
        }
    }

    private func updateData(profile: Profile) {

        view?.showLoading()

        favService.updateProfile(profile: profile) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                view?.showUIElements()

            case .failure:
                print("Update failed")
                view?.showUIElements()
                // TODO - Алерт об ошибке
            }
        }
    }
}
