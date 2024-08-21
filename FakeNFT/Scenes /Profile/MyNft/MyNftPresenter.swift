//
//  MyNftPresenter.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 19.08.2024.
//

import Foundation
import UIKit

protocol MyNftPresenterProtocol {
    func viewDidLoad()
    func sortNfts(by: SortKeys)
    var nfts: [NftResult] { get set }
}

enum SortKeys: String, CaseIterable {
    case name = "По имени"
    case price = "По цене"
    case rating = "По рейтингу"
}

final class MyNftPresenter: MyNftPresenterProtocol {
    
    weak var view: MyNftViewProtocol?
    
    var nfts: [NftResult] = []
    
    private let nftString: [String]
    
    private let nftService: NftServiceProtocol
    
    init(nftService: NftServiceProtocol, nftString: [String]) {
        self.nftString = nftString
        self.nftService = nftService
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
    
    // MARK: - Private
    
    private func loadNfts() {
        
        nfts.removeAll()
        
        let group = DispatchGroup()
        
        nftString.forEach { nft in
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
            
            if self.nfts.isEmpty {
                view?.showEmptyNfts()
            }
        }
    }
}
