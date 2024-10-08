//
//  MyNftTableViewCell.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 19.08.2024.
//

import UIKit
import Kingfisher

protocol MyNftTableViewCellDelegate: AnyObject {
    func didTapLike(needToAdd: Bool, id: String)
}

final class MyNftTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MyNftViewCell"

    weak var delegate: MyNftTableViewCellDelegate?

    private lazy var cellImage = {
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

    private lazy var titleLabel = {
        let title = UILabel()
        title.font = .bodyBold
        title.text = "Lilo"
        return title
    }()
    private lazy var rating = {
        let rating = [UIView()]
        return rating
    }()

    private lazy var author = {
        let name = UILabel()
        name.font = .caption2
        name.textColor = .textPrimary
        return name
    }()

    private lazy var priceLabel = {
        let price = UILabel()
        price.font = .caption2
        price.textColor = .textPrimary
        price.text = "Цена"
        return price
    }()

    private lazy var priceNum = {
        let price = UILabel()
        price.font = .bodyBold
        price.textColor = .textPrimary
        return price
    }()

    private lazy var nameStack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    private lazy var ratingStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        return stack
    }()

    private lazy var priceStack = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()

    private lazy var nftInfoStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    private var isLiked = false

    private var id = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)

        createStarsStack()
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(model: NftResult) {
        if let url = URL(string: model.image) {
            cellImage.kf.setImage(with: url)
        }
        titleLabel.text = model.name
        author.text = model.author
        priceNum.text = model.priceStr
        id = model.id
        isLiked = model.isLiked
        setStars(model.rating)
        likeButton.tintColor = isLiked ? .likeTintColor : .segmentInactive
    }

    private func setupCell() {

        nftInfoStack.addArrangedSubview(nameStack)
        nftInfoStack.addArrangedSubview(priceStack)

        nameStack.addArrangedSubview(titleLabel)
        nameStack.addArrangedSubview(ratingStack)
        nameStack.addArrangedSubview(author)

        priceStack.addArrangedSubview(priceLabel)
        priceStack.addArrangedSubview(priceNum)

        contentView.addSubview(cellImage)
        contentView.addSubview(nftInfoStack)
        contentView.addSubview(likeButton)

        NSLayoutConstraint.activate([

            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            cellImage.widthAnchor.constraint(equalToConstant: 108),
            cellImage.heightAnchor.constraint(equalToConstant: 108),

            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),

            nftInfoStack.topAnchor.constraint(equalTo: topAnchor, constant: 39),
            nftInfoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -39),
            nftInfoStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -29),
            nftInfoStack.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 20),

            nameStack.leadingAnchor.constraint(equalTo: nftInfoStack.leadingAnchor),
            nameStack.topAnchor.constraint(equalTo: nftInfoStack.topAnchor),
            nameStack.bottomAnchor.constraint(equalTo: nftInfoStack.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: nameStack.leadingAnchor),
            ratingStack.leadingAnchor.constraint(equalTo: nameStack.leadingAnchor),
            author.leadingAnchor.constraint(equalTo: nameStack.leadingAnchor),

            priceStack.topAnchor.constraint(equalTo: nftInfoStack.topAnchor, constant: 10),
            priceStack.bottomAnchor.constraint(equalTo: nftInfoStack.bottomAnchor, constant: -10),
            priceStack.trailingAnchor.constraint(equalTo: nftInfoStack.trailingAnchor),
            priceStack.leadingAnchor.constraint(equalTo: nameStack.trailingAnchor, constant: 39),

            priceLabel.leadingAnchor.constraint(equalTo: priceStack.leadingAnchor),
            priceNum.leadingAnchor.constraint(equalTo: priceStack.leadingAnchor)

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
        delegate?.didTapLike(needToAdd: !isLiked, id: id)
        isLiked.toggle()
    }
}
