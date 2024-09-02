import UIKit
import Kingfisher

final class CurrencyCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CurrencyCollectionViewCell"

    private let currencyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .tabBarItemsTintColor
        imageView.layer.cornerRadius = 6

        return imageView
    }()

    private let currencyName: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .tabBarItemsTintColor

        return label
    }()

    private let currencyShortName: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .yaGreen

        return label
    }()

    private let cellContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4

        return stackView
    }()

    private let currencyInfoContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical

        return stackView
    }()

    override var isSelected: Bool {
        didSet {
            configureBorder(isSelected: isSelected)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    func configCell(for model: CartCurrency) {
        currencyName.text = model.title
        currencyShortName.text = model.name
        setCurrencyImage(for: model)

    }

    private func setCurrencyImage(for model: CartCurrency) {
        guard let url = URL(string: model.image) else { return }
        currencyImage.kf.indicatorType = .activity
        (currencyImage.kf.indicator?.view as? UIActivityIndicatorView)?.color = .textSecondary
        currencyImage.kf.setImage(with: url, placeholder: UIImage(named: "cart.placeholder"))

    }

    private func setupUI() {
        backgroundColor = .segmentInactive
        layer.cornerRadius = 12

        setupViews()
        setupContainers()
    }

    private func setupViews() {
        [cellContainer,
         currencyInfoContainer
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    private func setupContainers() {
        cellContainer.addArrangedSubview(currencyImage)
        cellContainer.addArrangedSubview(currencyInfoContainer)

        currencyInfoContainer.addArrangedSubview(currencyName)
        currencyInfoContainer.addArrangedSubview(currencyShortName)

        NSLayoutConstraint.activate([
            cellContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            cellContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cellContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            cellContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])

        NSLayoutConstraint.activate([
            currencyImage.widthAnchor.constraint(equalToConstant: 36),
            currencyImage.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func configureBorder(isSelected: Bool) {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderColor = isSelected ? UIColor.tabBarItemsTintColor.cgColor : UIColor.clear.cgColor
        layer.borderWidth = isSelected ? 1 : 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configureBorder(isSelected: false)
    }
}
