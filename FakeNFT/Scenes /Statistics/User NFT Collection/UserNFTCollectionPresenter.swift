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

final class UserNFTCollectionPresenter: UserNFTCollectionPresenterProtocol {

    // MARK: - Public Properties
    weak var view: UserNFTCollectionVCProtocol?

    // MARK: - Private Properties
    private let servisesAssembly: ServicesAssembly
    private let userNFTService: UserNFTServiceProtocol
    private let profileService: ProfileServiceProtocol
    private let orderService: OrderServiceProtocol

    private let userNfts: [String]
    private var userNftsDetails: [NftDetails] = []
    private var faviriteNfts: [String] = []
    private var orderedNfts: [String] = []
    private var state: NFTCollectionPresenterState? {
        didSet {
            stateDidChanged()
        }
    }
    private var dataIsLoading = false
    private var collectionUpdateMethod: CollectionUpdateMethods = .insertItems
    private var firstIndexForReload = 0
    private var alertIsPresented = false

    private enum LoadedDataType {
        case profile(Profile), order(Order), newNft(NftDetails)
    }

    private enum LoadErrorCases {
        case profile(Error), order(Error), newNft(Error)
    }

    private enum NFTCollectionPresenterState {
        case preload, show, loadNft, data(LoadedDataType), failed(LoadErrorCases)
    }
    /*
     preload  - стейт предварительной загрузки данных профиля и корзины
     show     - стейт показа данных с проверкой необходимости подгрузки след. ячейки
     loadNft  - стейт загрузки данных nft
     failed   - стейт обработки ошибки при неудачной загрузке данных
     data     - стейт обработки данных при удачной загрузке из сети
     */

    // MARK: - Initializers
    init(userNfts: [String], servisesAssembly: ServicesAssembly) {
        self.userNfts = userNfts
        self.servisesAssembly = servisesAssembly
        self.userNFTService = servisesAssembly.userNFTService
        self.profileService = servisesAssembly.profileService
        self.orderService = servisesAssembly.orderService
    }

    // MARK: - Public Methods
    func viewWllAppear() {
        guard !userNfts.isEmpty else {
            return
        }

        firstIndexForReload = 0

        if userNftsDetails.count == userNfts.count {
            collectionUpdateMethod = .reloadItems
        }

        state = .preload
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
                     isFavorite: faviriteNfts.contains(userNfts[index]),
                     isInCart: orderedNfts.contains(userNfts[index])
        )
    }

    // MARK: - Private Methods
    private func stateDidChanged() {
        switch state {

        case .preload:
            preloadStateProcessing()

        case .show:
            showStateProcessing()

        case .loadNft:
            loadNftStateProcessing()

        case .data(let dataType):
            dataStateProcessing(dataType: dataType)

        case .failed(let errorCase):
            failedStateProcessing(errorCase: errorCase)

        case .none:
            assertionFailure("StatisticsPresenter can't move to initial state")
        }
    }

    private func preloadStateProcessing() {
        view?.showLoading()
        if faviriteNfts.isEmpty {
            self.loadProfile()
        } else if orderedNfts.isEmpty {
            self.loadOrder()
        } else {
            view?.hideLoading()
            state = .show
        }
    }

    private func showStateProcessing() {
        view?.updateCollectionItems(method: collectionUpdateMethod, indexes: getIndexesForReload())
        firstIndexForReload = userNftsDetails.count
        if userNftsDetails.count < userNfts.count {
            state = .loadNft
        }
    }

    private func loadNftStateProcessing() {
        if !dataIsLoading {
            dataIsLoading = true
            loadNextNft()
        }
    }

    private func dataStateProcessing(dataType: LoadedDataType) {
        dataIsLoading = false

        switch dataType {

        case .profile(let profile):
            faviriteNfts = profile.likes
            state = .preload

        case .order(let order):
            orderedNfts = order.nfts
            state = .loadNft

        case .newNft(let newNft):
            view?.hideLoading()
            self.userNftsDetails.append(newNft)
            collectionUpdateMethod = .insertItems
            state = .show
        }
    }

    private func failedStateProcessing(errorCase: LoadErrorCases) {
        if !alertIsPresented {
            alertIsPresented.toggle()
            view?.hideLoading()

            var primaryAction: () -> Void
            var returnedError: (any Error)

            switch errorCase {

            case .profile(let error):
                returnedError = error
                primaryAction = { [weak self] in
                    self?.alertDismissed()
                    self?.view?.showLoading()
                    self?.loadProfile()
                }

            case .order(let error):
                returnedError = error
                primaryAction = { [weak self] in
                    self?.alertDismissed()
                    self?.view?.showLoading()
                    self?.loadOrder()
                }

            case .newNft(let error):
                returnedError = error
                primaryAction = { [weak self] in
                    self?.alertDismissed()
                    self?.view?.showLoading()
                    self?.state = .show
                }
            }

            let errorModel = makeErrorModel(
                returnedError,
                primaryAction: primaryAction
            )

            view?.showError(errorModel)
        }
    }

    private func alertDismissed() {
        alertIsPresented = false
        dataIsLoading = false
    }

    private func loadProfile() {
        profileService.loadProfile {[weak self] result in
            switch result {
            case .success(let profileData):
                self?.state = .data(.profile(profileData))
            case .failure(let error):
                self?.state = .failed(.profile(error))
            }
        }
    }

    private func loadOrder() {
        orderService.loadOrder {[weak self] result in
            switch result {
            case .success(let orderData):
                self?.state = .data(.order(orderData))
            case .failure(let error):
                self?.state = .failed(.order(error))
            }
        }
    }

    private func loadNextNft() {
        userNFTService.loadNftDetails(id: userNfts[userNftsDetails.count]) {[weak self] result in
            switch result {
            case .success(let newNft):
                self?.state = .data(.newNft(newNft))
            case .failure(let error):
                self?.state = .failed(.newNft(error))
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

    private func makeErrorModel(_ error: Error, primaryAction: @escaping () -> Void) -> ErrorModel {

        let message: String = error is NetworkClientError
        ? .errorNetwork
        : .errorUnknown

        return .init(
            message: message,
            actionText: .buttonsRepeat,
            action: primaryAction,
            secondaryActionText: .buttonsCancel,
            secondaryAction: {self.alertDismissed()}
        )
    }
}

// MARK: - TrackersCVCellDelegate
extension UserNFTCollectionPresenter: UserNFTCollectionCellDelegate {

}
