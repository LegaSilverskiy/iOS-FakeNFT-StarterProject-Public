//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 13.08.2024.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {
    
    var title: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .bodyBold
        return title
    }()
    
    private lazy var arrow: UIImageView = {
        let imageArrow = UIImageView()
        imageArrow.translatesAutoresizingMaskIntoConstraints = false
        imageArrow.image = UIImage(systemName: "chevron.forward")
        imageArrow.tintColor = .textPrimary
        return imageArrow
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        addSubview(title)
        addSubview(arrow)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            title.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            arrow.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            arrow.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            arrow.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            arrow.heightAnchor.constraint(equalToConstant: 14),
            arrow.widthAnchor.constraint(equalToConstant: 14)
        ])
    }
}

