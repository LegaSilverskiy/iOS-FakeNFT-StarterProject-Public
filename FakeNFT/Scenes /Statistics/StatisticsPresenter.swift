//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 09.08.2024.
//

import Foundation

final class StatisticsPresenter {

    // MARK: - Public Properties
    weak var view: StatisticsViewController?
    
    // MARK: - Private Properties
    private let servicesAssembly: ServicesAssembly
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        
        self.servicesAssembly = servicesAssembly
    }

    // MARK: - Public Methods
    func sortButtonPressed() {
        guard let view else {
            return
        }
        
        ActionSheetPresenter.show(actionSheet: .actionSheetTitleSorting, with: [.name, .rating], on: view, delegate: self)
    }
    
    func getRatingMembersCount() -> Int {
        return 3
    }
    
    func getParams(for index: Int) -> RatingCellParams {
        
        return RatingCellParams(rating: index + 1,
                                avatar: nil,
                                name: "Michael Jackson",
                                NFTCount: getRatingMembersCount() - index
        )
    }
    
    func switchToProfile(for index: Int) {
        let vc = UserCardViewController(servicesAssembly: servicesAssembly)
        view?.navigationController?.pushViewController(vc, animated: true)
        print (index + 1)
    }
    
    // MARK: - Private Methods
   
}

// MARK: - ActionSheetPresenterDelegate
extension StatisticsPresenter: ActionSheetPresenterDelegate {
    
    func performSortig(with option: SortingOptions) {
        print(option)
    }
}
