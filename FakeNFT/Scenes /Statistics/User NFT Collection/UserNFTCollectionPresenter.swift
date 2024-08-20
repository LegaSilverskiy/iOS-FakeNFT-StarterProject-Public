//
//  UserNFTCollectionPresenter.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 21.08.2024.
//
import Foundation

protocol UserNFTCollectionPresenterProtocol: ActionSheetPresenterDelegate {
    
}

final class UserNFTCollectionPresenter: UserNFTCollectionPresenterProtocol {
    
    // MARK: - Public Properties
    weak var view: UserNFTCollectionVC?
    
    // MARK: - Private Properties
    private let userNFTService: UserNFTServiceProtocol
    
    // MARK: - Initializers
    init(userNFTService: UserNFTServiceProtocol) {
        
        self.userNFTService = userNFTService
    }
    
    // MARK: - Public Methods
    func sortingParametersUpdated(with option: SortingOptions) {
        
    }
    
    // MARK: - Private Methods
    
}
