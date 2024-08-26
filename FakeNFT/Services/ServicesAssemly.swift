final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorageImpl
    private let catalogStorage: CatalogStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorageImpl,
        catalogStorage: CatalogStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.catalogStorage = catalogStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var catalogService: CatalogServiceImpl {
            .init(
                networkClient: networkClient,
                storage: catalogStorage
            )
        }
    
    
    var profileService: ProfileServiceImpl {
        .init(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
    
    var orderService: OrderServiceImpl {
        .init(
            networkClient: networkClient,
            storage: nftStorage
        )
    }
}
