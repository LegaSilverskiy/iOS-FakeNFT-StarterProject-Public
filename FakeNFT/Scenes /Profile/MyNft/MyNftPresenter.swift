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
    func sortNfts(by: String)
    var nfts: [NftResult] { get set }
}

final class MyNftPresenter: MyNftPresenterProtocol {
    
    weak var view: MyNftViewProtocol?
    
    var nfts: [NftResult] = []
    
    var nftString: [String]
    
    private let nftService: NftServiceProtocol
    
    init(nftService: NftServiceProtocol, nftString: [String]) {
        self.nftString = nftString
        self.nftService = nftService
    }
    
    func viewDidLoad() {
        loadNfts()
    }
    
    func sortNfts(by option: String) {
        switch option {
        case "По цене":
            nfts = nfts.sorted(by: {
                $0.price < $1.price
            })
        case "По рейтингу":
            nfts = nfts.sorted(by: {
                $0.rating < $1.rating
            })
        case "По названию":
            nfts = nfts.sorted(by: {
                $0.name < $1.name
            })
            
        default:
            break
        }
        
        view?.showUIElements()
    }
    
    private func loadNfts() {
        
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
            self.view?.showUIElements()
            
            if self.nfts.isEmpty {
                view?.showEmptyNfts()
            }
        }
        
    }
}
