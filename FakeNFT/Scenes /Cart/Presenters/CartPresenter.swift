import Foundation

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
        
        nftsl = NftsMock.shared.nfts
        filteredNfts = nftsl
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
