import Foundation
import UIKit

protocol CartPresenterDelegate: AnyObject {
    func presentBlurredScreen()
}

final class CartPresenter {
    private weak var viewController: CartViewController?
    weak var delegate: CartPresenterDelegate?
    
    private var nftsl: [CartNftModel] = []
    private var filteredNfts: [CartNftModel] = []
    
    init(viewController: CartViewController) {
        self.viewController = viewController
        filteredNfts = nftsl
    }
    
    func loadNfts() {
        OrderService.shared.fetchOrders { [weak self] result in
            switch result {
            case .success(let order):
                let nftIds = order.nfts
                
                let dispatchGroup = DispatchGroup()
                var fetchedNfts: [CartNftModel] = []
                
                for nftId in nftIds {
                    dispatchGroup.enter()
                    OrderService.shared.fetchNFTByID(nftID: nftId) { result in
                        switch result {
                        case .success(let nft):
                            let numberFormatter = NumberFormatter()
                            numberFormatter.numberStyle = .decimal
                            numberFormatter.locale = Locale(identifier: "ru_RU")
                            
                            let priceString = numberFormatter.string(from: NSNumber(value: nft.price)) ?? "0,00"
                            
                            let cartNftModel = CartNftModel(
                                title: nft.name,
                                price: priceString + " ETH",
                                rating: nft.rating,
                                image: UIImage(named: "nft-1") ?? UIImage() 
                            )
                            fetchedNfts.append(cartNftModel)
                        case .failure(let error):
                            print("Failed to fetch NFT by ID: \(error)")
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self?.nftsl = fetchedNfts
                    self?.filteredNfts = fetchedNfts
                    self?.viewController?.reloadData()
                }
                
            case .failure(let error):
                print("Failed to fetch orders: \(error)")
            }
        }
    }
    
    func didTapButtonInCell() {
        delegate?.presentBlurredScreen()
    }
    
    func removeNft(at index: Int) {
        nftsl.remove(at: index)
    }
    
    func sortNft(by option: SortOption) {
        switch option {
        case .price:
            filteredNfts = nftsl.sorted(by: { $0.price < $1.price })
        case .rating:
            filteredNfts = nftsl.sorted(by: { $0.rating > $1.rating })
        case .name:
            filteredNfts = nftsl.sorted(by: { $0.title < $1.title })
        }
        
        viewController?.reloadData()
    }
    
    func getNft(at indexPath: IndexPath) -> CartNftModel{
        let nft = filteredNfts[indexPath.row]
        
        let cartNftModel = CartNftModel(
            title: nft.title,
            price: nft.price,
            rating: nft.rating,
            image: nft.image
        )
        
        return cartNftModel
    }
    
    func getNftsCount() -> Int {
        return filteredNfts.count
    }
}
