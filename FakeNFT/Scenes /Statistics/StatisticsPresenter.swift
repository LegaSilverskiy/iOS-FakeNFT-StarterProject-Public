//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 09.08.2024.
//
import Foundation

protocol StatisticsPresenterProtocol: ActionSheetPresenterDelegate {
    func viewDidLoad()
    func viewWllAppear()
    func sortButtonPressed()
    func getRatingMembersCount() -> Int
    func getParams(for index: Int) -> RatingCellParams
    func switchToProfile(for index: Int)
}

// MARK: - State
/*
 show          - стейт показа таблицы если на момент открытия вью, есть данные в переменной users
 loadNextPage  - стейт запроса данных из хранилища или сети
 failed        - стейт обработки ошибки при неудачной загрузке данных
 data          - стейт обработки данных при удачной загрузке из хранилища или сети
 */
enum StatisticsState {
    case show, loadNextPage, failed(Error), data([User])
}

enum UserDefaultsKeys: String {
    case ratingSortingOption
    case ratingSortingOrder
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: StatisticsViewProtocol?
    
    // MARK: - Private Properties
    private let usersService: UsersServiceProtocol
    private let pageSize = 15
    private var users: [User] = []
    private var state: StatisticsState? {
        didSet {
            stateDidChanged()
        }
    }
    private var sortingOption = SortingOptions.rating
    private var sortingOrder = SortingOrder.asc
    private var dataIsLoading = false
    private var loadIndicatorNeeded = true
    private var sortingNeeded = true
    private var alertIsPresented = false
    
    // MARK: - Initializers
    init(usersService: UsersServiceProtocol) {
        self.usersService = usersService
    }
    
    // MARK: - Public Methods
    
    func viewDidLoad() {
        
        getSavedSortingOptions()
    }
    
    func viewWllAppear() {
        
        if self.users.isEmpty {
            loadIndicatorNeeded = true
            sortingNeeded = true
            state = .loadNextPage
        } else {
            state = .show
        }
    }
    
    func sortButtonPressed() {
        view?.showSortMenu()
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
        view?.switchToUserCard(usersService: usersService)
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
            
        case .show:
            sortUsers()
            view?.updateTable()
            
        case .loadNextPage:
            if !dataIsLoading {
                if loadIndicatorNeeded {
                    view?.showLoading()
                }
                dataIsLoading = true
                loadUsers()
            }
            
        case .data(let users):
            dataIsLoading = false
            view?.hideLoading()
            self.users.append(contentsOf: users)
            loadIndicatorNeeded = false
            if sortingNeeded {
                sortingNeeded.toggle()
                sortUsers()
            }
            view?.updateTable()
            
        case .failed(let error):
            view?.hideLoading()
            if !alertIsPresented {
                alertIsPresented.toggle()
                let errorModel = makeErrorModel(error)
                view?.showError(errorModel)
            }
            
        case .none:
            assertionFailure("StatisticsPresenter can't move to initial state")
        }
    }
    
    private func loadUsers() {
        usersService.loadUsers(
            itemsLoaded: users.count,
            pageSize: pageSize
        ) {[weak self] result in
            switch result {
            case .success(let users):
                self?.state = .data(users)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    
    private func endOfListCheck(for row: Int) {
        if row >= users.count - 5 {
            state = .loadNextPage
        }
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
            
        case is NetworkClientError:
            message = .errorNetwork
            
        default:
            message = .errorUnknown
        }
        
        return ErrorModel(
            message: message,
            actionText: .buttonsRepeat,
            action: { [weak self] in
                self?.alertIsPresented = false
                self?.dataIsLoading = false
                self?.state = .loadNextPage
            },
            secondaryActionText: .buttonsCancel,
            secondaryAction: { [weak self] in
                self?.alertIsPresented = false
                self?.dataIsLoading = false
            }
        )
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
        view?.updateTable()
    }
}
