import UIKit
import Kingfisher

protocol CartTableViewCellDelegate: AnyObject {
    func didTapButton(in cell: CartTableViewCell, at indexPath: IndexPath, with image: String)
}

final class CartTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CartTableViewCell"
    weak var delegate: CartTableViewCellDelegate?

    private var indexPath: IndexPath?
    private var imageURL: String?
    private var stars: [UIView] = []

    private let nftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let cellContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center

        return stackView
    }()

    private let nftContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 20

        return stackView
    }()

    private let nftInfoContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12

        return stackView
    }()

    private let nftHeaderContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4

        return stackView
    }()

    private let nftRatingContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 4

        return stackView
    }()

    private let priceContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4

        return stackView
    }()

    private lazy var cartDeleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .tabBarItemsTintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "cart.delete"), for: .normal)
        button.addTarget(self, action: #selector(cartDeleteButtonPressed), for: .touchUpInside)
        return button
    }()

    private let nftTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .tabBarItemsTintColor

        return label
    }()

    private let nftPriceTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .tabBarItemsTintColor

        return label
    }()

    private let nftPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.bodyBold
        label.textColor = .tabBarItemsTintColor

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupContainers()
        setupNftImage()
        setupCartDeleteButton()
        setupRatingStars()
    }

    func configCell(with model: CartNftModel, at indexPath: IndexPath) {
        self.indexPath = indexPath
        nftTitle.text = model.title
        nftPrice.text = model.price
        imageURL = model.image

        guard let url = URL(string: model.image) else { return }
        nftImage.kf.indicatorType = .activity
        (nftImage.kf.indicator?.view as? UIActivityIndicatorView)?.color = .textSecondary
        nftImage.kf.setImage(with: url, placeholder: UIImage(named: "cart.placeholder"))
        nftImage.layer.cornerRadius = 12
        nftImage.clipsToBounds = true

        updateRatingStars(with: model.rating)
    }

    private func setupContainers() {
        contentView.addSubview(cellContainer)

        cellContainer.addArrangedSubview(nftContainer)

        nftContainer.addArrangedSubview(nftImage)
        nftContainer.addArrangedSubview(nftInfoContainer)

        nftInfoContainer.addArrangedSubview(nftHeaderContainer)
        nftInfoContainer.addArrangedSubview(priceContainer)

        nftHeaderContainer.addArrangedSubview(nftTitle)
        nftHeaderContainer.addArrangedSubview(nftRatingContainer)

        priceContainer.addArrangedSubview(nftPriceTitle)
        priceContainer.addArrangedSubview(nftPrice)

        NSLayoutConstraint.activate([
            cellContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cellContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func setupNftImage() {
        NSLayoutConstraint.activate([
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.widthAnchor.constraint(equalToConstant: 108)
        ])
    }

    private func setupCartDeleteButton() {
        cellContainer.addArrangedSubview(cartDeleteButton)

        NSLayoutConstraint.activate([
            cartDeleteButton.heightAnchor.constraint(equalToConstant: 40),
            cartDeleteButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupRatingStars() {
        stars = (0..<5).map { _ in
            let star = UIImageView()

            star.image = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12))
            star.translatesAutoresizingMaskIntoConstraints = false
            star.contentMode = .scaleAspectFit
            star.tintColor = .segmentInactive
            nftRatingContainer.addArrangedSubview(star)

            return star
        }
    }

    private func updateRatingStars(with rating: Int) {
        for (index, star) in stars.enumerated() {
            star.tintColor = index < rating ? .yaYellow : .segmentInactive
        }
    }

    @objc
    private func cartDeleteButtonPressed() {
        guard let indexPath = indexPath, let imageURL = imageURL else { return }
        delegate?.didTapButton(in: self, at: indexPath, with: imageURL)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nftImage.kf.cancelDownloadTask()
    }
}
