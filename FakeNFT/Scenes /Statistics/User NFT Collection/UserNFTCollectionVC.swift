//
//  UserNFTCollectionVC.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 21.08.2024.
//
import UIKit

protocol UserNFTCollectionVCProtocol: AnyObject, ErrorView {
    func showLoading()
    func hideLoading()
    func updateCollectionItems(method: CollectionUpdateMethods, indexes: [IndexPath])
    func showError(_ model: ErrorModel)
}

final class UserNFTCollectionVC: UIViewController, UserNFTCollectionVCProtocol {
    
    // MARK: - Private Properties
    private let presenter: UserNFTCollectionPresenter
    private let cellSize = CGSize(width: 108, height: 192)
    
    private lazy var nftCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(UserNFTCollectionCell.self, forCellWithReuseIdentifier: UserNFTCollectionCell.reuseIdentifier)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .systemBackground
        collection.showsVerticalScrollIndicator = false
        
        return collection
    }()
    
    private lazy var stubLabel: UILabel = {
        let label = UILabel()
        label.text = .userNFTCollectionVCNoNfts
        label.font = .bodyBold
        label.textColor = .tabBarItemsTintColor
        
        return label
    }()
    
    
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
        
        presenter.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter.viewWllAppear()
    }
    
    // MARK: - Public Methods
    
    func showLoading() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoading() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func updateCollectionItems(method: CollectionUpdateMethods, indexes: [IndexPath]) {
        
        switch method {
            
        case .insertItems:
            nftCollection.insertItems(at: indexes)
            
        case .reloadItems:
            nftCollection.reloadItems(at: indexes)
            
        case .reloadData:
            nftCollection.reloadData()
        }
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
        setElements()
        setConstraints()
    }
    
    private func setElements() {
        [nftCollection,
         stubLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        stubLabel.isHidden = !presenter.showStub()
    }
    
    private func setConstraints() {
        
        nftCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        nftCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        nftCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        nftCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        stubLabel.constraintCenters(to: view)
    }
    
}

// MARK: - UICollectionViewDataSource
extension UserNFTCollectionVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getItemsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserNFTCollectionCell.reuseIdentifier, for: indexPath) as? UserNFTCollectionCell {
            cell.delegate = presenter
            
            let params = presenter.getParams(for: indexPath.item)
            cell.configure(with: params)
            
            return cell
        }
        
        debugPrint("@@@ UserNFTCollectionVC: Ошибка подготовки ячейки для коллекции NFT.")
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserNFTCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}
