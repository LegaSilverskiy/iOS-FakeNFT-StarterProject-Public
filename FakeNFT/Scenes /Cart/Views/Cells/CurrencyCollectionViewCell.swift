import UIKit

final class CurrencyCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CurrencyCollectionViewCel"
    
    private let currencyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "btc")
        imageView.layer.cornerRadius = 6
        
        return imageView
    }()
    
    private let currencyName: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .tabBarItemsTintColor
        label.text = "Bitcoin"
        
        return label
    }()
    
    private let currencyShortName: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .yaGreen
        label.text = "BTC"
        
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        setupViews()
        setupContainers()
    }
    
    private func setupViews() {
        [cellContainer,
         currencyInfoContainer
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
