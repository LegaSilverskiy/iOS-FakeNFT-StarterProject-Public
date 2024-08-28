//
//  CustomCellTableView.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/13/24.
//

import UIKit
import Kingfisher

final class CustomCellForTableView: UITableViewCell, ReuseIdentifying {
    
    static let reUseIdentifier = "TableInCatalogCustomViewCell"
    
    //MARK: - Private UI Properties
    private lazy var imageCollectionNFT = UIImageView()
    private lazy var titleLabelForCollectionNFT = UILabel()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public Methods
    func configure(with params: CatalogCell) {
        titleLabelForCollectionNFT.text = String("\(params.name.capitalizingFirstLetter())"+" (\(params.nfts.count))")
        if let url = URL(string: params.cover) {
            setupImageWithKf(with: url)
        }
    }
    
    func setupImageWithKf(with url: URL) {
        imageCollectionNFT.kf.setImage(with: url, placeholder: UIImage.tabBarIconsCatalog?.withTintColor(.mainTextColor))
    }
    
    //MARK: - Overrides Methods
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageCollectionNFT.kf.cancelDownloadTask()
    }
    
    
}

//MARK: - CONSTRAINTS
extension CustomCellForTableView {
    
    private func setupConstraints() {
        
        imageCollectionNFT.translatesAutoresizingMaskIntoConstraints = false
        titleLabelForCollectionNFT.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageCollectionNFT.topAnchor.constraint(equalTo: topAnchor),
            imageCollectionNFT.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageCollectionNFT.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageCollectionNFT.heightAnchor.constraint(equalToConstant: 140),
            imageCollectionNFT.bottomAnchor.constraint(equalTo: titleLabelForCollectionNFT.topAnchor, constant: -4),
            
            titleLabelForCollectionNFT.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabelForCollectionNFT.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21)
        ])
    }
}

// MARK: - Private Methods
private extension CustomCellForTableView {
    func configureUI() {
        configureView()
        addSubviews()
        setupConstraints()
        configureTitleLabel()
        configImageView()
    }
    
    func configImageView() {
        imageCollectionNFT.layer.cornerRadius = 14
        imageCollectionNFT.layer.masksToBounds = true
        imageCollectionNFT.contentMode = .scaleAspectFill
    }
    
    func addSubviews() {
        addSubview(imageCollectionNFT)
        addSubview(titleLabelForCollectionNFT)
    }
    
    func configureView() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
    }
    
    func configureTitleLabel() {
        titleLabelForCollectionNFT.font = .bodyBold
    }
    
    func setTitleLabelText(with text: String) {
        titleLabelForCollectionNFT.text = text
    }
}
