//
//  FavouritesCollectionViewCell.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 22.08.2024.
//

import UIKit

protocol FavouriteCellDelegate: AnyObject {
    func didTapLike(id: String)
}

final class FavouritesCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "MyFavouritesNftViewCell"

    weak var delegate: FavouriteCellDelegate?

    private lazy var image = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()

    private lazy var likeButton = {
        let like = UIButton()
        like.translatesAutoresizingMaskIntoConstraints = false
        like.setImage(UIImage(named: "Like"), for: .normal)
        like.addTarget(self, action: #selector(tapLike), for: .touchUpInside)
        return like
    }()

    private lazy var title = {
        let title = UILabel()
        title.font = .bodyBold
        return title
    }()

    private lazy var rating = {
        let rating = [UIView()]
        return rating
    }()

    private lazy var price = {
        let price = UILabel()
        price.font = .caption1
        price.textColor = .textPrimary
        return price
    }()

    private lazy var nameStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private lazy var ratingStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 2
        return stack
    }()

    private var isLiked = true

    private var id = ""

    override init(frame: CGRect) {
        super.init(frame: frame)

        createStarsStack()
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(model: NftResult) {
        if let url = URL(string: model.image) {
            image.kf.setImage(with: url)
        }
        title.text = model.name
        price.text = model.priceStr
        setStars(model.rating)
        id = model.id
    }

    private func setupCell() {

        likeButton.tintColor = .red

        nameStack.addArrangedSubview(title)
        nameStack.addArrangedSubview(ratingStack)
        nameStack.addArrangedSubview(price)

        addSubview(image)
        addSubview(likeButton)
        addSubview(nameStack)

        NSLayoutConstraint.activate([

            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            image.widthAnchor.constraint(equalToConstant: 80),
            image.heightAnchor.constraint(equalToConstant: 80),

            likeButton.topAnchor.constraint(equalTo: image.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),

            nameStack.topAnchor.constraint(equalTo: topAnchor),
            nameStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameStack.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 12),

            title.leadingAnchor.constraint(equalTo: nameStack.leadingAnchor),
            ratingStack.leadingAnchor.constraint(equalTo: nameStack.leadingAnchor),
            price.leadingAnchor.constraint(equalTo: nameStack.leadingAnchor)

        ])
    }

    private func createStarsStack() {
        rating = (0..<5).map { _ in
            let starImageView = UIImageView()
            starImageView.image = UIImage(
                systemName: "star.fill",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 12)
            )
            starImageView.tintColor = .yellow
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            ratingStack.addArrangedSubview(starImageView)
            return starImageView
        }

        for starImageView in rating {
            starImageView.setContentHuggingPriority(.required, for: .horizontal)
            starImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
    }

    private func setStars(_ stars: Int) {
        for (index, star) in rating.enumerated() {
            star.tintColor = index < stars ? .yellow : .segmentInactive
        }
    }

    @objc private func tapLike() {

        isLiked.toggle()
        delegate?.didTapLike(id: id)
    }
}
