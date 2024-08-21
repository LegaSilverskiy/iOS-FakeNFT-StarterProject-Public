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
    
    //MARK: - PRIVATE UI PROPERTIES
    private lazy var imageCollectionNFT = UIImageView()
    private lazy var titleLabelForCollectionNFT = UILabel()
    
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - PUBLIC METHODS
    func configure(with params: CatalogCell) {
        titleLabelForCollectionNFT.text = String("\(params.name.prefix(18))"+" (\(params.nfts.count))")
        if let url = URL(string: params.cover) {
            setupImageWithKf(with: url)
        }
    }
    
    func setupImageWithKf(with url: URL) {
        imageCollectionNFT.kf.setImage(with: url, placeholder: UIImage.tabBarIconsCatalog?.withTintColor(.black))
    }
    
    //MARK: - OVERRIDE METHODS
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageCollectionNFT.kf.cancelDownloadTask()
    }
    
    // MARK: - CONFIGURE UI
    private func configureUI() {
        configureView()
        addSubviews()
        setupConstraints()
        configureTitleLabel()
        configImageView()
    }
    
    private func configImageView() {
        imageCollectionNFT.layer.cornerRadius = 14
        imageCollectionNFT.layer.masksToBounds = true
    }
    
    private func addSubviews() {
        addSubview(imageCollectionNFT)
        addSubview(titleLabelForCollectionNFT)
    }
    
    private func configureView() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
    }
    
    private func configureTitleLabel() {
        titleLabelForCollectionNFT.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    private func setTitleLabelText(with text: String) {
        titleLabelForCollectionNFT.text = text
    }
}

//MARK: - CONSTRAINTS
extension CustomCellForTableView {
    
    private func setupConstraints() {
        imageCollectionNFT.translatesAutoresizingMaskIntoConstraints = false
        titleLabelForCollectionNFT.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageCollectionNFT.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageCollectionNFT.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageCollectionNFT.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageCollectionNFT.heightAnchor.constraint(equalToConstant: 179),
            
            imageCollectionNFT.bottomAnchor.constraint(equalTo: titleLabelForCollectionNFT.topAnchor, constant: -4),
            
            titleLabelForCollectionNFT.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabelForCollectionNFT.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -21)
        ])
    }
}
