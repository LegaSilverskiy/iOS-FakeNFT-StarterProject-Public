import Foundation

final class Mock {
    
    static let shared = Mock()
    
    var currencies: [CartCurrency] = [
        CartCurrency(
            title: "Bitcoin",
            name: "BTC",
            image: "btc",
            id: 0
        ),
        
        CartCurrency(
            title: "Dogecoin",
            name: "DOGE",
            image: "doge",
            id: 1
        ),
        
        CartCurrency(
            title: "Tether",
            name: "USDT",
            image: "usdt",
            id: 2
        ),
        
        CartCurrency(
            title: "Apecoin",
            name: "APE",
            image: "ape",
            id: 3
        ),
        
        CartCurrency(
            title: "Solana",
            name: "SOL",
            image: "sol",
            id: 4
        ),
        
        CartCurrency(
            title: "Ethereum",
            name: "ETH",
            image: "eth",
            id: 5
        ),
        
        CartCurrency(
            title: "Cardano",
            name: "ADA",
            image: "ada",
            id: 6
        ),
        
        CartCurrency(
            title: "Shiba Inu",
            name: "SHIB",
            image: "shib",
            id: 7
        )
    ]
}
