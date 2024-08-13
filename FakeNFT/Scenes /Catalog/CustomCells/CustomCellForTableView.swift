//
//  CustomCellTableView.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/13/24.
//

import UIKit

final class CustomCellForTableView: UITableViewCell {
    
    static let identiferForCellInTableView = "TableInCatalogCustomViewCell"
    
    //MARK: - PRIVATE UI PROPERTIES
    private let frameViewForTable = UIView()
    private let imageCollectionNFT = UIImageView()
    private let titleLabelForCollectionNFT = UILabel()
    
//    // MARK: - INIT
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    //MARK: - PUBLIC METHODS
    func configure() {
        
    }
    
    // MARK: - CONFIGURE UI
    private func configureUI() {
        configureView()
        addSubviews()
        setupConstraints()
        configureTitleLabel()
        configureFrameView()
    }
    
    private func addSubviews() {
        contentView.addSubview(frameViewForTable)
        frameViewForTable.addSubview(imageCollectionNFT)
        frameViewForTable.addSubview(titleLabelForCollectionNFT)
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
    
    // MARK: - FRAME VIEW
    private func configureFrameView() {
        frameViewForTable.layer.masksToBounds = true
        frameViewForTable.layer.cornerRadius = 10
        frameViewForTable.layer.cornerCurve = .continuous
    }
    
}

    //MARK: - CONSTRAINTS
extension CustomCellForTableView {
    
    private func setupConstraints() {
        frameViewForTable.translatesAutoresizingMaskIntoConstraints = false
        imageCollectionNFT.translatesAutoresizingMaskIntoConstraints = false
        titleLabelForCollectionNFT.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            frameViewForTable.topAnchor.constraint(equalTo: contentView.topAnchor),
            frameViewForTable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            frameViewForTable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            frameViewForTable.heightAnchor.constraint(equalToConstant: 179),
            
            imageCollectionNFT.topAnchor.constraint(equalTo: frameViewForTable.topAnchor),
            imageCollectionNFT.leadingAnchor.constraint(equalTo: frameViewForTable.leadingAnchor),
            imageCollectionNFT.trailingAnchor.constraint(equalTo: frameViewForTable.trailingAnchor),
            imageCollectionNFT.bottomAnchor.constraint(equalTo: titleLabelForCollectionNFT.topAnchor, constant: 4),
            
            titleLabelForCollectionNFT.topAnchor.constraint(equalTo: imageCollectionNFT.bottomAnchor, constant: 4),
            titleLabelForCollectionNFT.leadingAnchor.constraint(equalTo: frameViewForTable.leadingAnchor),
            titleLabelForCollectionNFT.trailingAnchor.constraint(equalTo: frameViewForTable.trailingAnchor),
            titleLabelForCollectionNFT.bottomAnchor.constraint(equalTo: frameViewForTable.bottomAnchor)
        ])
    }
}
