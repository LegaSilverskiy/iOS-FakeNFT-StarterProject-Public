import Foundation
import UIKit

protocol CartPresenterDelegate: AnyObject {
    func presentBlurredScreen(with indexPath: IndexPath)
    func deleteFromCart(at indexPath: IndexPath)
}

protocol CartView: AnyObject {
    func reloadData()
    func deleteRows(at indexPath: IndexPath)
    func presentBlurredScreen(with indexPath: IndexPath)
}

final class CartPresenter {
    weak var view: CartView?
    weak var delegate: CartPresenterDelegate?
    private let interactor: CartInteractorProtocol
    
    private var nftsl: [CartNftModel] = []
    private var filteredNfts: [CartNftModel] = []
    
    init(interactor: CartInteractorProtocol) {
        self.interactor = interactor
    }
    
    func setView(_ view: CartView) {
        self.view = view
    }
    
    func loadNfts() {
        interactor.fetchNfts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedNfts):
                self.nftsl = fetchedNfts
                self.filteredNfts = fetchedNfts
                self.view?.reloadData()
                
            case .failure(let error):
                print("Failed to fetch orders: \(error)")
            }
        }
    }
    
    func didTapButtonInCell(at indexPath: IndexPath) {
        delegate?.presentBlurredScreen(with: indexPath)
    }
    
    func deleteFromCart(at indexPath: IndexPath) {
        filteredNfts.remove(at: indexPath.row)
        view?.deleteRows(at: indexPath)
        
        let nftsIDs = filteredNfts.map { $0.id }
        
        interactor.updateOrder(with: nftsIDs) { [weak self] result in
            switch result {
            case .success:
                self?.loadNfts()
            case .failure(let error):
                print("Ошибка: \(error.localizedDescription)")
            }
        }
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
        
        view?.reloadData()
    }
    
    func getNft(at indexPath: IndexPath) -> CartNftModel{
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
    
    func getNftsCount() -> Int {
        return filteredNfts.count
    }
        
}
