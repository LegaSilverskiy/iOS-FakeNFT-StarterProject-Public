//
//  UserNFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 21.08.2024.
//
import Foundation

protocol UserNFTCollectionPresenterProtocol {
}

// MARK: - State
/*
 load     - стейт запроса данных из сети
 show     -
 failed   - стейт обработки ошибки при неудачной загрузке данных
 data     - стейт обработки данных при удачной загрузке из сети
 */
enum NFTCollectionPresenterState {
    case load, show, failed(Error), data(NftDetails)
}

final class UserNFTCollectionPresenter: UserNFTCollectionPresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: UserNFTCollectionVCProtocol?
    
    // MARK: - Private Properties
    private let userNfts: [String]
    private var userNftsDetails: [NftDetails] = []
    private let servisesAssembly: ServicesAssembly
    private let userNFTService: UserNFTServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let orderService: OrderServiceProtocol
    private var state: NFTCollectionPresenterState? {
        didSet {
            stateDidChanged()
        }
    }
    private var dataIsLoading = false
    private var collectionUpdateMethod: CollectionUpdateMethods = .insertItems
    private var loadIndicatorNeeded = true
    private var firstIndexForReload = 0
    private var alertIsPresented = false
    
    // MARK: - Initializers
    init(userNfts: [String], servisesAssembly: ServicesAssembly) {
        self.userNfts = userNfts
        self.servisesAssembly = servisesAssembly
        self.userNFTService = servisesAssembly.userNFTService
        self.profileService = servisesAssembly.profileService
        self.orderService = servisesAssembly.orderService
    }
    
    // MARK: - Public Methods
    func viewDidLoad() {
        
    }
    
    func viewWllAppear() {
        //        firstIndexForReload = userNftsDetails.count
        firstIndexForReload = 0
        
        if userNftsDetails.count < userNfts.count {
            state = .load
        } else {
            collectionUpdateMethod = .reloadItems
            state = .show
        }
    }
    
    func showStub() -> Bool {
        userNfts.isEmpty
    }
    
    func getItemsCount() -> Int {
        userNftsDetails.count
    }
    
    func getParams(for index: Int) -> NftCellParams {
        let nft = userNftsDetails[index]
        return .init(index: index,
                     name: nft.name,
                     image: nft.images[0],
                     rating: nft.rating,
                     price: nft.price,
                     isFavorite: true,
                     isInCart: true
        )
    }
    
    // MARK: - Private Methods
    private func stateDidChanged() {
        switch state {
            
        case .show:
            view?.updateCollectionItems(method: collectionUpdateMethod, indexes: getIndexesForReload())
            firstIndexForReload = userNftsDetails.count
            if userNftsDetails.count < userNfts.count {
                state = .load
            }
            
        case .load:
            if !dataIsLoading {
                if loadIndicatorNeeded {
                    view?.showLoading()
                }
                dataIsLoading = true
                loadNextNft()
            }
            
        case .data(let newNft):
            dataIsLoading = false
            view?.hideLoading()
            self.userNftsDetails.append(newNft)
            loadIndicatorNeeded = false
            collectionUpdateMethod = .insertItems
            state = .show
            
        case .failed(let error):
            view?.hideLoading()
            if !alertIsPresented {
                alertIsPresented.toggle()
                let errorModel = makeErrorModel(error)
                view?.showError(errorModel)
            }
            
        case .none:
            assertionFailure("StatisticsPresenter can't move to initial state")
        }
    }
    
    private func loadNextNft() {
        userNFTService.loadNftDetails(id: userNfts[userNftsDetails.count]) {[weak self] result in
            switch result {
            case .success(let newNft):
                self?.state = .data(newNft)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func getIndexesForReload() -> [IndexPath] {
        var indexes: [IndexPath] = []
        for index in firstIndexForReload ..< userNftsDetails.count {
            indexes.append(.init(item: index, section: 0))
        }
        return(indexes)
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
            
        case is NetworkClientError:
            message = .errorNetwork
            
        default:
            message = .errorUnknown
        }
        
        return ErrorModel(
            message: message,
            actionText: .buttonsRepeat,
            action: { [weak self] in
                self?.alertIsPresented = false
                self?.dataIsLoading = false
                self?.state = .load
            },
            secondaryActionText: .buttonsCancel,
            secondaryAction: { [weak self] in
                self?.alertIsPresented = false
                self?.dataIsLoading = false
            }
        )
    }
    
}

// MARK: - TrackersCVCellDelegate
extension UserNFTCollectionPresenter: UserNFTCollectionCellDelegate {
    
}
