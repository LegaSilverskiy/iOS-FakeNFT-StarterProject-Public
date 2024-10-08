import Foundation

protocol CartPresenterProtocol: AnyObject {
    var view: CartView? { get set }
    func viewDidLoad()
    func loadNfts()
    func deleteFromCart(at indexPath: IndexPath)
    func clearCart()
    func showSortOptions() -> [AlertButtonAction]
    func getNft(at indexPath: IndexPath) -> CartNftModel
    func getNftsCount() -> [CartNftModel]
    func formattedTotalPrice() -> String
}

final class CartPresenter: CartPresenterProtocol {
    weak var view: CartView?
    private let interactor: CartInteractorProtocol

    private let sortOptionKey = "selectedCartSortOption"
    private var nftModels: [CartNftModel] = []
    private var filteredNfts: [CartNftModel] = []

    init(interactor: CartInteractorProtocol) {
        self.interactor = interactor
        saveSortOption(.name)
    }

    func viewDidLoad() {
        loadNfts()
        resetChosenCurrency()
    }

    func loadNfts() {
        view?.showHud()
        interactor.fetchNfts { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let fetchedNfts):
                nftModels = fetchedNfts
                filteredNfts = fetchedNfts

                let savedSortOption = self.loadSortOption()
                sortNft(by: savedSortOption)

                DispatchQueue.main.async {
                    self.view?.reloadData()
                    self.view?.hideHud()
                }
            case .failure(let error):
                print("Failed to fetch orders: \(error)")
            }
        }
    }

    func deleteFromCart(at indexPath: IndexPath) {
        filteredNfts.remove(at: indexPath.row)
        view?.deleteRows(at: indexPath)

        let nftsIDs = filteredNfts.map { $0.id }

        interactor.updateOrder(with: nftsIDs) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.loadNfts()
                }
            case .failure(let error):
                print("Ошибка: \(error.localizedDescription)")
            }
        }
    }

    func clearCart() {
        deleteAllItemsInCart()
        filteredNfts.removeAll()
    }

    func showSortOptions() -> [AlertButtonAction] {
        let sortOptions: [(title: String, option: SortOption)] = [
            (.sortingOptionsPrice, .price),
            (.sortingOptionsRating, .rating),
            (.sortingOptionsName, .name)
        ]

        var actions = sortOptions.map { option in
            createSortAction(title: option.title, sortOption: option.option)
        }

        let cancelAction = AlertButtonAction(buttonTitle: .buttonsClose, style: .cancel, action: nil)
        actions.append(cancelAction)

        return actions
    }

    func getNft(at indexPath: IndexPath) -> CartNftModel {
        let nft = filteredNfts[indexPath.row]

        let cartNftModel = CartNftModel(
            id: nft.id,
            title: nft.title,
            price: nft.price,
            rating: nft.rating,
            image: nft.image
        )

        return cartNftModel
    }

    func getNftsCount() -> [CartNftModel] {
        filteredNfts
    }

    func formattedTotalPrice() -> String {
        let totalPrice = getNftsTotalPrice()

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2

        let formattedPrice = numberFormatter.string(from: NSNumber(value: totalPrice)) ?? "0,00"

        return formattedPrice + " ETH"
    }

    private func sortNft(by option: SortOption) {
        saveSortOption(option)
        switch option {
        case .price:
            filteredNfts = nftModels.sorted { nft1, nft2 in
                let price1 = nft1.price.replacingOccurrences(
                    of: " ETH",
                    with: ""
                ).replacingOccurrences(
                    of: ",",
                    with: "."
                )
                let price2 = nft2.price.replacingOccurrences(
                    of: " ETH",
                    with: ""
                ).replacingOccurrences(
                    of: ",",
                    with: "."
                )

                let priceValue1 = Double(price1) ?? 0.0
                let priceValue2 = Double(price2) ?? 0.0

                return priceValue1 > priceValue2
            }
        case .rating:
            filteredNfts = nftModels.sorted(by: { $0.rating > $1.rating })
        case .name:
            filteredNfts = nftModels.sorted(by: { $0.title < $1.title })
        }

        view?.reloadData()
    }

    private func saveSortOption(_ option: SortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: sortOptionKey)
    }

    private func loadSortOption() -> SortOption {
        let savedOption = UserDefaults.standard.string(forKey: sortOptionKey) ?? SortOption.name.rawValue
        return SortOption(rawValue: savedOption) ?? .name
    }

    private func getNftsTotalPrice() -> Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "ru_RU")

        let totalPrice = filteredNfts.reduce(0.0) { (result, nft) -> Double in
            let priceString = nft.price
            let priceNumber = numberFormatter.number(
                from: priceString.replacingOccurrences(
                    of: " ETH",
                    with: ""
                )
            )?.doubleValue ?? 0.0

            return result + priceNumber
        }
        return totalPrice
    }

    private func createSortAction(title: String, sortOption: SortOption) -> AlertButtonAction {
        return AlertButtonAction(buttonTitle: title, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.sortNft(by: sortOption)
        }
    }

    private func resetChosenCurrency() {
        UserDefaults.standard.removeObject(forKey: "SelectedCurrencyIndex")
    }

    private func deleteAllItemsInCart() {
        interactor.updateOrder(with: []) { result in
            switch result {
            case .success:
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    view?.reloadData()
                }
            case .failure(let error):
                print("Ошибка при очистке корзины: \(error.localizedDescription)")
            }
        }
    }
}
