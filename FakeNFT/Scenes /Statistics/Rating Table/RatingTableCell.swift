//
//  RatingTableCell.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 09.08.2024.
//
import Kingfisher
import UIKit


final class RatingTableCell: UITableViewCell {
    
    // MARK: - Private Properties
    private let ratingLabel = UILabel()
    private var avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let nftCountLabel = UILabel()
    private let bgView = UIView()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with params: RatingCellParams) {
        
        ratingLabel.text = String(params.rating)
        
        if let url = URL(string: params.avatar) {
            updateUserImage(url: url)
        }
        
        nameLabel.text = params.name
        nftCountLabel.text = String(params.NFTCount)
    }
    
    // MARK: - Private Methods
    private func updateUserImage(url: URL) {
        avatarImageView.kf.indicatorType = .activity
        
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage.tabBarIconsProfile?.withTintColor(.avatarStubTintColor)
        )
    }
    
    private func setUIElements() {
        
        selectionStyle = .none
        
        bgView.backgroundColor = .segmentInactive
        bgView.layer.cornerRadius = 12
        bgView.layer.masksToBounds = true
        
        ratingLabel.font = .caption1
        ratingLabel.textColor = .tabBarItemsTintColor
        
        avatarImageView = UIImageView(image: UIImage.tabBarIconsProfile?.withTintColor(.avatarStubTintColor))
        avatarImageView.backgroundColor = .segmentInactive
        avatarImageView.layer.cornerRadius = 14
        avatarImageView.layer.masksToBounds = true
        
        nameLabel.font = .headline3
        nameLabel.textAlignment = .left
        nameLabel.textColor = .tabBarItemsTintColor
        
        nftCountLabel.font = .headline3
        nftCountLabel.textAlignment = .right
        nftCountLabel.textColor = .tabBarItemsTintColor
        
        [bgView, ratingLabel, avatarImageView, nameLabel, nftCountLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            bgView.heightAnchor.constraint(equalToConstant: 80),
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            
            ratingLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            ratingLabel.centerXAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            
            avatarImageView.heightAnchor.constraint(equalToConstant: 28),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16),
            
            nameLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -70),
            
            nftCountLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            nftCountLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16)
        ])
    }
}
