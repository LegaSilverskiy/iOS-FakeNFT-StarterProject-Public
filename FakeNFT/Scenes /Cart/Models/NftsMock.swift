import UIKit

final class NftsMock {
    static let shared = NftsMock()
    
    var nfts: [CartNftModel] = [
        CartNftModel(
            id: "1",
            title: "April",
            price: "1,78 ETH",
            rating: 1,
            image: UIImage(named: "nft-1") ?? UIImage()
        ),
        
        CartNftModel(
            id: "2",
            title: "Greena",
            price: "3 ETH",
            rating: 3,
            image: UIImage(named: "nft-2") ?? UIImage()
        ),
        
        CartNftModel(
            id: "3",
            title: "Spring",
            price: "2 ETH",
            rating: 5,
            image: UIImage(named: "nft-3") ?? UIImage()
        )
    ]
}
