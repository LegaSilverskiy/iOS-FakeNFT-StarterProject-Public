//
//  UserNFTCollectionVC.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 21.08.2024.
//
import UIKit

protocol UserNFTCollectionVCProtocol: AnyObject, ErrorView {
    
    func showError(_ model: ErrorModel)
}

final class UserNFTCollectionVC: UIViewController, UserNFTCollectionVCProtocol {
    
    // MARK: - Private Properties
    private let ratingTableRowHeight = 88.0
    
    private let presenter: UserNFTCollectionPresenter
    private var ratingTable = UITableView()
    
    // MARK: - Initializers
    init(presenter: UserNFTCollectionPresenter) {
        
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        presenter.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //        presenter.viewWllAppear()
    }
    
    // MARK: - Public Methods
    
    func showLoading() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoading() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func updatetable() {
        ratingTable.reloadData()
    }
    
    // MARK: - Private Methods
    private func navBarConfig() {
        let titleView = UILabel()
        titleView.text = .userNFTCollectionVCTitle
        titleView.textColor = .tabBarItemsTintColor
        titleView.font = .bodyBold
        navigationItem.titleView = titleView
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
        navBarConfig()
    }
}
