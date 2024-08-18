import UIKit

protocol CartInteractorProtocol {
    func fetchNfts(completion: @escaping (Result<[CartNftModel], Error>) -> Void)
    func updateOrder(with nftsIds: [String], completion: @escaping (Result<Void, Error>) -> Void)
}

final class CartInteractor: CartInteractorProtocol {
    
    func fetchNfts(completion: @escaping (Result<[CartNftModel], Error>) -> Void) {
        OrderService.shared.fetchOrders { result in
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
                                id: nftId,
                                title: nft.name,
                                price: priceString + " ETH",
                                rating: nft.rating,
                                image: nft.images.first ?? "cart.placeholder"
                            )
                            fetchedNfts.append(cartNftModel)
                        case .failure(let error):
                            print("Failed to fetch NFT by ID: \(error)")
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    completion(.success(fetchedNfts))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateOrder(with nftsIds: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        OrderService.shared.updateOrder(nftsIds: nftsIds) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
