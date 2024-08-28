//
//  CurrentCollectionNftPresenter.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/22/24.
//

import Foundation

final class CurrentCollectionNftPresenter {
    
    //MARK: - Properties
    weak var view: CurrentCollectionNftViewController?
    var nfts: [Nft] = []
    
    //MARK: - Private properties
    private let service: ServicesAssembly
    private var profile: Profile?
    private var catalogNfts: Catalog?
    
    // MARK: - Initializers
    init(service: ServicesAssembly, nftCollection: Catalog?) {
        self.service = service
        self.catalogNfts = nftCollection
        self.getProfile()
    }
    
    //MARK: - Public methods
    func getNftCollection() {
        guard let catalogNfts else { return }
        catalogNfts.nfts.forEach {
            view?.showLoading()
            service.nftService.loadNft(id: $0, completion: { [weak self] result in
                self?.view?.hideLoading()
                switch result {
                case .success(let nft):
                    self?.nfts.append(nft)
                    self?.view?.reloadData()
                case .failure(let error):
                    self?.view?.showErrorAlert()
                    print(error)
                }
            })
        }
    }
    
    func loadData() {
        guard let catalogNfts,
              let coverToUrl = URL(string: catalogNfts.cover) else { return }
        view?.setupData(
            name: catalogNfts.name,
            cover: coverToUrl,
            author: catalogNfts.author,
            description: catalogNfts.description)
    }
    
    func getCellModel(for indexPath: IndexPath) -> CurrentCollectionCell {
        convertToCellModel(nft: nfts[indexPath.row])
    }
    
    //MARK: - Private methods
    private func convertToCellModel(nft: Nft) -> CurrentCollectionCell {
        .init(
            id: nft.id,
            nameNft: nft.name,
            price: nft.price,
            isLiked: service.profileService.likeState(for: nft.id),
            isInTheCart: service.orderService.cartState(for: nft.id),
            rating: nft.rating,
            url: nft.images[0]
        )
    }
    
    private func getProfile() {
        service.profileService.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
            case .failure(let error):
                print(error)
            }
        }
    }
}
