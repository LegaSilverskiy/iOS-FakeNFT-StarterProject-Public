//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 09.08.2024.
//
import Foundation

// MARK: - State

enum StatisticsState {
    case start, loadNextPage, reloadList, failed(Error), data([User])
}

enum UserDefaultsKeys: String {
    case ratingSortingOption
    case ratingSortingOrder
}

final class StatisticsPresenter {
    
    // MARK: - Public Properties
    weak var view: StatisticsViewController?
    
    // MARK: - Private Properties
    private let servicesAssembly: ServicesAssembly
    private let service: UsersService
    private var users: [User] = []
    private var pagesLoaded = 0
    private var pageSize = 15
    private var state: StatisticsState? {
        didSet {
            stateDidChanged()
        }
    }
    private var sortingOption = SortingOptions.rating
    private var sortingOrder = SortingOrder.asc
    private var dataIsLoading = false
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        self.service = servicesAssembly.usersService
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        state = .start
    }
    
    func sortButtonPressed() {
        guard let view else {
            return
        }
        
        ActionSheetPresenter.show(actionSheet: .actionSheetTitleSorting, with: [.name, .rating], on: view, delegate: self)
    }
    
    func getRatingMembersCount() -> Int {
        return users.count
    }
    
    func getParams(for index: Int) -> RatingCellParams {
        endOfListCheck(for: index)
        
        return RatingCellParams(rating: Int(users[index].rating) ?? 0,
                                avatar: users[index].avatar,
                                name: users[index].name,
                                NFTCount: users[index].nfts.count
        )
    }
    
    func switchToProfile(for index: Int) {
        let vc = UserCardViewController(servicesAssembly: servicesAssembly)
        view?.navigationController?.pushViewController(vc, animated: true)
        print (index + 1)
    }
    
    // MARK: - Private Methods
    private func getSavedSortingOptions() {
        let sortingOption = UserDefaults.standard.string(forKey: UserDefaultsKeys.ratingSortingOption.rawValue)
        let sortingOrder = UserDefaults.standard.string(forKey: UserDefaultsKeys.ratingSortingOrder.rawValue)
        
        self.sortingOption = sortingOption == SortingOptions.name.rawValue
        ? .name
        : .rating
        
        self.sortingOrder = sortingOrder == SortingOrder.desc.rawValue
        ? .desc
        : .asc
    }
    
    private func saveSortingOptions(sortingOption: SortingOptions, sortingOrder: SortingOrder) {
        UserDefaults.standard.set(sortingOption.rawValue, forKey: UserDefaultsKeys.ratingSortingOption.rawValue)
        UserDefaults.standard.set(sortingOrder.rawValue, forKey: UserDefaultsKeys.ratingSortingOrder.rawValue)
    }
    
    private func stateDidChanged() {
        switch state {
            
        case .start:
            view?.showLoading()
            dataIsLoading = true
            getSavedSortingOptions()
            print(sortingOption)
            loadUsers(page: 1,
                      pageSize: pageSize,
                      reloadMode: false
            )
            
        case .loadNextPage:
            dataIsLoading = true
            loadUsers(page: pagesLoaded + 1,
                      pageSize: pageSize,
                      reloadMode: false
            )
            
        case .reloadList:
            dataIsLoading = true
            loadUsers(page: 1,
                      pageSize: pageSize,
                      reloadMode: true
            )
            
        case .data(let users):
            dataIsLoading = false
            view?.hideLoading()
            self.users = users
            self.pagesLoaded = self.users.count / self.pageSize
            if pagesLoaded == 1 {
                sortUsers()
            }
            view?.updatetable()
            
        case .failed(let error):
            dataIsLoading = false
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
            
        case .none:
            assertionFailure("StatisticsPresenter can't move to initial state")
        }
    }
    
    private func loadUsers(page: Int,
                           pageSize: Int,
                           reloadMode: Bool
    ) {
        service.loadUsers(page: page,
                          pageSize: pageSize,
                          reloadMode: reloadMode
        ) { [weak self] result in
            switch result {
            case .success(let users):
                self?.state = .data(users)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func endOfListCheck(for row: Int) {
        if row == users.count - 3 && !dataIsLoading {
            state = .loadNextPage
        }
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loadNextPage
        }
    }
    
    private func sortUsers() {
        switch self.sortingOption {
        case .name:
            users = users.sorted(by: {
                self.sortingOrder == .asc
                ? $0.name < $1.name
                : $0.name > $1.name
            })
        case .rating:
            users = users.sorted(by: {
                self.sortingOrder == .asc
                ? Int($0.rating) ?? 0 > Int($1.rating) ?? 0
                : Int($0.rating) ?? 0 < Int($1.rating) ?? 0
            })
        }
    }
    
}

// MARK: - ActionSheetPresenterDelegate
extension StatisticsPresenter: ActionSheetPresenterDelegate {
    
    func sortingParametersUpdated(with option: SortingOptions) {
        saveSortingOptions(sortingOption: option, sortingOrder: .asc)
        self.sortingOption = option
        self.sortingOrder = .asc
        sortUsers()
        view?.updatetable()
    }
}
