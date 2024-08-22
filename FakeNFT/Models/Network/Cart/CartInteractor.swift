import UIKit

protocol CartInteractorProtocol {
    func fetchNfts(completion: @escaping (Result<[CartNftModel], Error>) -> Void)
    func updateOrder(with nftsIds: [String], completion: @escaping (Result<Void, Error>) -> Void)
}

final class CartInteractor: CartInteractorProtocol {
    private let service = OrderService.shared
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func fetchNfts(completion: @escaping (Result<[CartNftModel], Error>) -> Void) {
        service.fetchOrders { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let order):
                let nftIds = order.nfts
                
                let dispatchGroup = DispatchGroup()
                var fetchedNfts: [CartNftModel] = []
                
                for nftId in nftIds {
                    dispatchGroup.enter()
                    service.fetchNFTByID(nftID: nftId) { result in
                        switch result {
                        case .success(let nft):
                            let model = self.convertNft(id: nftId, nft: nft)
                            fetchedNfts.append(model)
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
        service.updateOrder(nftsIds: nftsIds) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    private func convertNft(id: String, nft: CartNft) -> CartNftModel {
        let priceString = numberFormatter.string(from: NSNumber(value: nft.price)) ?? "0,00"
        return .init(
            id: id,
            title: nft.name,
            price: priceString + " ETH",
            rating: nft.rating,
            image: nft.images.first ?? "cart.placeholder"
        )
    }
}
