final class ServicesAssembly {

    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    private let usersStorage: UsersStorage

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage,
        usersStorage: UsersStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
        self.usersStorage = usersStorage
    }

    var nftService: NftService {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
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
}
