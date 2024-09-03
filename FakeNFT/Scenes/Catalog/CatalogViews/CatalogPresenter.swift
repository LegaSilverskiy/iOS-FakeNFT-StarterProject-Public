//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/16/24.
//

import Foundation

enum Sort: String {
    case byName
    case byCount
}

final class CatalogPresenter {

    weak var view: CatalogViewController?

    // MARK: - Private Properties
    private let servicesAssembly: ServicesAssembly
    private let sortKey = "sortKey"
    private let userDefaults = UserDefaults.standard
    private var state: StatesOfCatalog? {
        didSet {
            stateDidChange()
        }
    }
    // MARK: - Public Methods

    func viewDidLoad() {
        state = .loading
    }

    func viewWllAppear() {
        guard catalogs.isEmpty else { return }
        state = .loading
    }

    // MARK: - Private Properties
    private let service: CatalogService
    var catalogs: [Catalog] = []

    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        self.service = servicesAssembly.catalogService
    }

    // MARK: - Public Methods
    func getParamsForCell(for index: Int) -> CatalogCell {
        .init(
            name: catalogs[index].name,
            cover: catalogs[index].cover,
            id: catalogs[index].id,
            nfts: catalogs[index].nfts
        )
    }

    func getAllCatalogs() -> Int {

        return catalogs.count
    }

    func sortByCount() {
        saveSort(.byCount)
        catalogs = catalogs.sorted { $0.nfts.count > $1.nfts.count }
        view?.updatetable()
    }

    func sortByName() {
        saveSort(.byName)
        catalogs = catalogs.sorted { $0.name < $1.name }
        view?.updatetable()
    }
}

// MARK: - Private Methods
private extension CatalogPresenter {

    func saveSort(_ type: Sort) {
        userDefaults.set(type.rawValue, forKey: sortKey)
    }

    func getSort() -> Sort {
        guard let value = userDefaults.value(forKey: sortKey) as? String else { return Sort.byCount }
        return Sort(rawValue: value) ?? Sort.byCount
    }

    func checkSort() {
        switch getSort() {
        case .byName:
            sortByName()
        case .byCount:
            sortByCount()
        }
    }

    func loadCatalogs() {
        service.loadCatalogs {[weak self] result in
            switch result {
            case .success(let catalogs):
                self?.state = .data(catalogs)
                self?.checkSort()
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }

    func stateDidChange() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showProgressHud()
            loadCatalogs()
            view?.updatetable()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.showError(errorModel)
            view?.hideProgressHud()
        case .data(let catalog):
            self.catalogs.append(contentsOf: catalog)
            view?.updatetable()
            view?.hideProgressHud()
        case .none:
            assertionFailure("StatisticsPresenter can't move to initial state")
        }
    }

    func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("error.network", comment: "")
        default:
            message = NSLocalizedString("error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("buttons.repeat", comment: "")

        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}
