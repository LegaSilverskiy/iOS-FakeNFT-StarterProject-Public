//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/16/24.
//

import Foundation

final class CatalogPresenter {

    weak var view: CatalogViewController?
    
    //MARK: - SERVICESASSEMBLY
    private let servicesAssembly: ServicesAssembly
    
    private var state: StatesOfCatalog? {
        didSet {
            stateDidChange()
        }
    }
    
    //MARK: - LOADING_STATES
    
    func viewDidLoad() {
        state = .loading
    }
    
    func viewWllAppear() {
        state = .loading
    }
    
    //MARK: - PRIVATE_PROPERTIES
    private let service: CatalogServiceImpl
    private var catalogs: [Catalog] = []
    
    //MARK: - INIT
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        self.service = servicesAssembly.catalogService
    }
    
    //MARK: - PUBLIC_METHODS
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
    
    private func loadCatalogs() {
        service.loadCatalogs() {[weak self] result in
            switch result {
            case .success(let catalogs):
                self?.state = .data(catalogs)
            case .failure(let error):
                self?.state = .failed(error)
            }
        }
    }
    //MARK: - PRIVATE_METHODS
    private func stateDidChange() {
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
