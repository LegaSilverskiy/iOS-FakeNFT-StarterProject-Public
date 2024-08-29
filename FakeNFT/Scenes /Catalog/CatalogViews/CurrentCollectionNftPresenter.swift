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
    private var likes: [String] = []
    private var orders: [String] = []
    
    // MARK: - Initializers
    init(service: ServicesAssembly, nftCollection: Catalog?) {
        self.service = service
        self.catalogNfts = nftCollection
    }
    
    //MARK: - Public methods
    func getNftCollection() {
        
        guard let catalogNfts else { return }
        view?.showLoading()
        
        service.profileService.loadLikes{ [weak self] result in
            switch result {
            case .success(let profile):
                self?.likes = profile.likes
            case .failure:
                self?.view?.showErrorAlert()
            }
            self?.view?.hideLoading()
        }
        
        service.orderService.loadOrders{ [weak self] result in
            switch result {
            case .success(let orders):
                self?.orders = orders.nfts
            case .failure:
                self?.view?.showErrorAlert()
            }
            self?.view?.hideLoading()
        }
        
        catalogNfts.nfts.forEach {
            service.nftService.loadNft(id: $0) { [weak self] result in
                switch result {
                case .success(let nft):
                    self?.nfts.append(nft)
                    self?.view?.hideLoading()
                    self?.view?.reloadData()
                case .failure:
                    self?.view?.showErrorAlert()
                }
                self?.view?.hideLoading()
            }
        }
    }
    
    func updateLikeState(for indexPath: IndexPath) {
        view?.showLoading()
        let nftId = nfts[indexPath.row].id
        var updatedLikes = self.likes
        
        if updatedLikes.contains(nftId) {
            updatedLikes.removeAll { $0 == nftId }
        } else {
            updatedLikes.append(nftId)
        }
        self.likes = updatedLikes
        
        service.profileService.setLike(id: nftId, likes: self.likes, completion: { [weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                guard !profile.likes.isEmpty else { return }
                self?.likes = profile.likes
                self?.view?.updateCell(indexPath: indexPath)
                
            case .failure:
                self?.view?.showErrorAlert()
            }
            self?.view?.hideLoading()
        })
    }
    
    func updateOrderState(for indexPath: IndexPath) {
        view?.showLoading()
        let nftId = nfts[indexPath.row].id
        var updatedOrders = self.orders
        
        if updatedOrders.contains(nftId) {
            updatedOrders.removeAll { $0 == nftId }
        } else {
            updatedOrders.append(nftId)
        }
        self.orders = updatedOrders
        
        service.orderService.setOrders(id: nftId, orders: self.orders, completion: { [weak self] result in
            switch result {
            case .success(let orders):
                guard !orders.nfts.isEmpty else { return }
                self?.orders = orders.nfts
                self?.view?.updateCell(indexPath: indexPath)
                self?.view?.hideLoading()
            case .failure:
                self?.view?.showErrorAlert()
            }
            self?.view?.hideLoading()
        })
    }
    
    func getAuthorURL() -> URL? {
        let authorURL = URL(string: "https://practicum.yandex.ru")
        return authorURL
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
            isLiked: likes.contains(nft.id),
            isInTheCart: orders.contains(nft.id),
            rating: nft.rating,
            url: nft.images[0]
        )
    }
}
