final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let catalogStorage: CatalogStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
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
}
