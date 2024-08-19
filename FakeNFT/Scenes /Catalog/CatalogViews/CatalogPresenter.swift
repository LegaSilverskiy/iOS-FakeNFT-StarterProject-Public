//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/16/24.
//

import Foundation
import Combine

final class CatalogPresenter {
    @Published var catalogs: [Catalog] = []
    
    //MARK: - LINK_TO_CATALOG_VIEW_CONTROLLR
    weak var view: CatalogViewController?
    
    //MARK: - SERVICESASSEMBLY
    let servicesAssembly: ServicesAssembly
    
    //MARK: STATE
    private var state: StatesOfCatalog? {
        didSet {
            stateDidChange()
        }
    }
    
    //MARK: - VIEW_DID_LOAD
    
    func viewDidLoad() {
        state = .loading
    }
    
    //MARK: - VIEW_WILL_APPEARE
    func viewWllAppear() {
        state = .loading
    }
    
    //MARK: - SERVICE
    private let service: CatalogServiceImpl
    //MARK: - INIT
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        self.service = servicesAssembly.catalogService
    }
    
    //MARK: - GET_PARAMS_FOR_CELL
    func getParamsForCell(for index: Int) -> CatalogCell {
        return CatalogCell(name: catalogs[index].name, cover: catalogs[index].cover,id: catalogs[index].id, nfts: catalogs[index].nfts)
    }
    
    //MARK: - GET_ALL_CATALOGS_FOR_COUNT
    func getAllCatalogs() -> Int {
        return catalogs.count
    }
    
    //MARK: - LOAD_CATALOGS
    func loadCatalogs() {
        service.loadCatalogs() {[weak self] result in
            switch result {
            case .success(let catalogs):
                self?.state = .data(catalogs)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    //MARK: - CHANGE_STATE
    private func stateDidChange() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showProgressHud()
            view?.showLoading()
            loadCatalogs()
            view?.updatetable()
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
            view?.hideProgressHud()
        case .data(let catalog):
            view?.hideLoading()
            self.catalogs.append(contentsOf: catalog)
            view?.updatetable()
            view?.hideProgressHud()
        case .none:
            assertionFailure("StatisticsPresenter can't move to initial state")
        }
    }
    
    //MARK: - ERROR MODEL
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
            self?.state = .loading
        }
    }
}
