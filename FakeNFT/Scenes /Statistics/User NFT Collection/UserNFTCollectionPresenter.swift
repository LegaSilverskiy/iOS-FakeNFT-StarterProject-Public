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
    private let favoritesService: FavoritesServiceProtocol
    private let orderService: OrderServiceProtocol

    private let userNfts: [String]
    private var userNftsDetails: [NftDetails] = []
    private var favoriteNfts: [String] = []
    private var updatedFavoriteNfts: [String] = []
    private var orderedNfts: [String] = []
    private var updatedOrderedNfts: [String] = []
    private var state: NFTCollectionPresenterState? {
        didSet {
            stateDidChanged()
        }
    }
    private var dataLoading = false
    private var dataUpdating = false
    private var collectionUpdateMethod: CollectionUpdateMethods = .insertItems
    private var currentlyUpdatedNftIndex: Int?
    private var firstIndexForReload = 0
    private var alertIsPresented = false

    private enum LoadedDataType {
        case favorites(Favorites), order(Order), newNft(NftDetails)
    }

    private enum LoadErrorCases {
        case profile(Error), order(Error), newNft(Error)
    }

    private enum UpdateErrorCases {
        case favorites(Error), order(Error)
    }

    private enum NftUpdateCases {
        case favorite, order
    }

    private enum NFTCollectionPresenterState {
        case preload,                        // предварительная загрузка данных (избранное / корзина)
             show,                           // обновление коллекции, проверка необходимости подгрузки след. ячейки
             loadNft,                        // загрузка данных NFT
             updateNFT(NftUpdateCases),      // обновление статуса NFT (в избранном / в корзине)
             loadSuccess(LoadedDataType),    // загрузка данных NFT прошла удачно
             loadFailure(LoadErrorCases),    // обработка ошибки при неудачной загрузке данных NFT
             updateSuccess(NftUpdateCases),  // обновление статуса (в избранном / в корзине) прошло удачно
             updateFailure(UpdateErrorCases) // ошибка обновления статуса (в избранном / в корзине)
    }

    // MARK: - Initializers
    init(userNfts: [String], servisesAssembly: ServicesAssembly) {
        self.userNfts = userNfts
        self.servisesAssembly = servisesAssembly
        self.userNFTService = servisesAssembly.userNFTService
        self.favoritesService = servisesAssembly.favoritesService
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
                     price: "\(String(nft.price)) ETH",
                     isFavorite: favoriteNfts.contains(userNfts[index]),
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

        case .updateNFT(let option):
            updateNftStateProcessing(with: option)

        case .loadSuccess(let dataType):
            dataStateProcessing(dataType: dataType)

        case .loadFailure(let errorCase):
            failedStateProcessing(errorCase: errorCase)

        case .updateSuccess(let option):
            updateSuccessStateProcessing(with: option)

        case .updateFailure(let errorCase):
            updateFailureStateProcessing(errorCase: errorCase)

        case .none:
            assertionFailure("StatisticsPresenter can't move to initial state")
        }
    }

    private func preloadStateProcessing() {
        view?.showLoading()
        if favoriteNfts.isEmpty {
            self.getFavoriteNfts()
        } else if orderedNfts.isEmpty {
            self.getOrderedNfts()
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
        if !dataLoading {
            dataLoading = true
            loadNextNft()
        }
    }

    private func updateNftStateProcessing(with option: NftUpdateCases) {
        view?.showLoading()
        if !dataUpdating {
            dataUpdating = true
        }

        switch option {

        case .favorite:
            updateFavoriteNfts()

        case .order:
            updateOrderedNfts()
        }
    }

    private func dataStateProcessing(dataType: LoadedDataType) {
        dataLoading = false

        switch dataType {

        case .favorites(let profile):
            favoriteNfts = profile.likes
            state = .preload

        case .order(let order):
            orderedNfts = order.nfts
            state = .loadNft

        case .newNft(let newNft):
            view?.hideLoading()
            userNftsDetails.append(newNft)
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
                    self?.getFavoriteNfts()
                }

            case .order(let error):
                returnedError = error
                primaryAction = { [weak self] in
                    self?.alertDismissed()
                    self?.view?.showLoading()
                    self?.getOrderedNfts()
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

    private func updateSuccessStateProcessing(with option: NftUpdateCases) {
        view?.hideLoading()
        dataUpdating = false

        if option == .favorite {
            favoriteNfts = updatedFavoriteNfts
        } else {
            orderedNfts = updatedOrderedNfts
        }
        collectionUpdateMethod = .reloadItems
        state = .show
    }

    private func updateFailureStateProcessing(errorCase: UpdateErrorCases) {
        if !alertIsPresented {
            alertIsPresented.toggle()
            view?.hideLoading()
            dataUpdating = false

            var primaryAction: () -> Void
            var returnedError: (any Error)

            switch errorCase {

            case .favorites(let error):
                returnedError = error
                primaryAction = { [weak self] in
                    self?.alertDismissed()
                    self?.view?.showLoading()
                    self?.state = .updateNFT(.favorite)
                }

            case .order(let error):
                returnedError = error
                primaryAction = { [weak self] in
                    self?.alertDismissed()
                    self?.view?.showLoading()
                    self?.state = .updateNFT(.order)
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
        dataLoading = false
    }

    private func getFavoriteNfts() {
        favoritesService.sendFavoritesRequest(httpMethod: .get, favoriteNfts: nil) {[weak self] result in
            switch result {
            case .success(let profileData):
                self?.state = .loadSuccess(.favorites(profileData))
            case .failure(let error):
                self?.state = .loadFailure(.profile(error))
            }
        }
    }

    private func updateFavoriteNfts() {
        favoritesService.sendFavoritesRequest(httpMethod: .put, favoriteNfts: updatedFavoriteNfts) {[weak self] result in
            switch result {
            case .success:
                self?.state = .updateSuccess(.favorite)
            case .failure(let error):
                self?.state = .updateFailure(.favorites(error))
            }
        }
    }

    private func getOrderedNfts() {
        orderService.sendOrderRequest(httpMethod: .get, orderedNfts: nil) {[weak self] result in
            switch result {
            case .success(let orderData):
                self?.state = .loadSuccess(.order(orderData))
            case .failure(let error):
                self?.state = .loadFailure(.order(error))
            }
        }
    }

    private func updateOrderedNfts() {
        orderService.sendOrderRequest(httpMethod: .put, orderedNfts: orderedNfts) {[weak self] result in
            switch result {
            case .success:
                self?.state = .updateSuccess(.order)
            case .failure(let error):
                self?.state = .updateFailure(.order(error))
            }
        }
    }

    private func loadNextNft() {
        userNFTService.loadNftDetails(id: userNfts[userNftsDetails.count]) {[weak self] result in
            switch result {
            case .success(let newNft):
                self?.state = .loadSuccess(.newNft(newNft))
            case .failure(let error):
                self?.state = .loadFailure(.newNft(error))
            }
        }
    }

    private func getIndexesForReload() -> [IndexPath] {
        var indexes: [IndexPath] = []
        if let currentlyUpdatedNftIndex {
            indexes.append(.init(item: currentlyUpdatedNftIndex, section: 0))
            self.currentlyUpdatedNftIndex = nil
            return(indexes)
        }

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
    func updateNftFavoriteStatus(index: Int) {
        guard !dataUpdating else {
            return
        }
        dataUpdating.toggle()

        currentlyUpdatedNftIndex = index
        let currentlyUpdatedNftID = userNftsDetails[index].id
        updatedFavoriteNfts = favoriteNfts
        if updatedFavoriteNfts.contains(currentlyUpdatedNftID) {
            updatedFavoriteNfts = updatedFavoriteNfts.filter {nftID in
                nftID != currentlyUpdatedNftID
            }
        } else {
            updatedFavoriteNfts.append(currentlyUpdatedNftID)
        }

        state = .updateNFT(.favorite)
    }

    func updateNftOrderStatus(index: Int) {
        guard !dataUpdating else {
            return
        }
        dataUpdating.toggle()

        currentlyUpdatedNftIndex = index
        let currentlyUpdatedNftID = userNftsDetails[index].id
        updatedOrderedNfts = orderedNfts
        if updatedOrderedNfts.contains(currentlyUpdatedNftID) {
            updatedOrderedNfts = updatedOrderedNfts.filter {nftID in
                nftID != currentlyUpdatedNftID
            }
        } else {
            updatedOrderedNfts.append(currentlyUpdatedNftID)
        }
        state = .updateNFT(.order)
    }
}
