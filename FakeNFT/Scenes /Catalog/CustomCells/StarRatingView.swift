//
//  StarRatingView.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/26/24.
//

import UIKit

final class StarRatingView: UIStackView {
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func update(rating: Int) {
        updateRating(rating: rating)
    }
    
    // MARK: - Private methods
    private func updateRating(rating: Int) {
        for (index, subview) in arrangedSubviews.enumerated() {
            guard let starImageView = subview as? UIImageView else { continue }
            starImageView.image = index < rating ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            starImageView.tintColor = .yelowForStars
        }
    }
    
    private func configure() {
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(systemName: "star")
            starImageView.contentMode = .scaleAspectFit
            addArrangedSubview(starImageView)
        }
    }
}
