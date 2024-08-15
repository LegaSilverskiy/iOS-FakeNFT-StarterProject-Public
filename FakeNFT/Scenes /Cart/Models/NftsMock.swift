import UIKit

final class NftsMock {
    static let shared = NftsMock()
    
    var nfts: [CartNftModel] = [
        CartNftModel(
            title: "April",
            price: "1,78 ETH",
            rating: 1,
            image: UIImage(named: "nft-1") ?? UIImage()
        ),
        
        CartNftModel(
            title: "Greena",
            price: "3 ETH",
            rating: 3,
            image: UIImage(named: "nft-2") ?? UIImage()
        ),
        
        CartNftModel(
            title: "Spring",
            price: "2 ETH",
            rating: 5,
            image: UIImage(named: "nft-3") ?? UIImage()
        )
    ]
}
