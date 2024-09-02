final class ServicesAssembly {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let usersStorage: UsersStorage

    private let catalogStorage: CatalogStorage
    
    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        usersStorage: UsersStorage,
        catalogStorage: CatalogStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.usersStorage = usersStorage
        self.catalogStorage = catalogStorage
    }
    
    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }

    var profileService: ProfileServiceProtocol {
        ProfileService(networkClient: networkClient)
    }

    var usersService: UsersServiceProtocol {
        UsersService(
            networkClient: networkClient,
            storage: usersStorage
        )
    }

    var userNFTService: UserNFTServiceProtocol {
        UserNFTService(
            networkClient: networkClient
        )
    }

    var favoritesService: FavoritesServiceProtocol {
        FavoritesService(
            networkClient: networkClient
        )
    }

    var orderService: OrderServiceProtocol {
        OrderService(
            networkClient: networkClient
        )
    }
    
    var catalogService: CatalogService {
        .init(
            networkClient: networkClient,
            storage: catalogStorage
        )
    }
    
    var profileServiceCatalog: ProfileServiceCatalog {
        .init(
            networkClient: networkClient
        )
    }
    
    var orderServiceCatalog: OrderServiceCatalog {
        .init(
            networkClient: networkClient
        )
    }
}
