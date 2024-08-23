import UIKit

final class CartDeleteViewController: UIViewController {
    
    private weak var delegate: CartView?
    private var indexPath: IndexPath
    private var imageURL: String
    
    init(delegate: CartView, indexPath: IndexPath, imageURL: String) {
        self.delegate = delegate
        self.indexPath = indexPath
        self.imageURL = imageURL
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mainContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
    
        return stackView
    }()
    
    private let nftInfoContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12
        
        return stackView
    }()
    
    private let buttonsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let nftImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let warningMessage: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .tabBarItemsTintColor
        label.text = "Вы уверены, что хотите \nудалить объект из корзины?"
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)

        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .tabBarItemsTintColor
        button.titleLabel?.font = UIFont.bodyRegular
        
        button.setTitleColor(.yaRed, for: .normal)
        button.setTitle("Удалить", for: .normal)
        button.addTarget(self, action: #selector(deleteFromCart), for: .touchUpInside)
        
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
   
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .tabBarItemsTintColor
        button.titleLabel?.font = UIFont.bodyRegular
        
        button.setTitleColor(.textOnPrimary, for: .normal)
        button.setTitle("Вернуться", for: .normal)
        button.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setBlurEffect()
        setupViews()
        setupNftImage()
        setupContainers()
    }
    
    private func setupViews() {
        [mainContainer,
         nftInfoContainer,
         buttonsContainer
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurEffectView)
    }
    
    private func setupContainers() {
        mainContainer.addArrangedSubview(nftInfoContainer)
        mainContainer.addArrangedSubview(buttonsContainer)
        
        nftInfoContainer.addArrangedSubview(nftImage)
        nftInfoContainer.addArrangedSubview(warningMessage)
        
        buttonsContainer.addArrangedSubview(deleteButton)
        buttonsContainer.addArrangedSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            mainContainer.widthAnchor.constraint(equalToConstant: 262),
            mainContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            nftImage.heightAnchor.constraint(equalToConstant: 108)
        ])
    }
    
    private func setupNftImage() {
        guard let url = URL(string: imageURL) else { return }
        nftImage.kf.indicatorType = .activity
        (nftImage.kf.indicator?.view as? UIActivityIndicatorView)?.color = .textSecondary
        nftImage.kf.setImage(with: url, placeholder: UIImage(named: "cart.placeholder"))
        nftImage.layer.cornerRadius = 12
        nftImage.clipsToBounds = true
    }
    
    @objc private func deleteFromCart() {
        delegate?.deleteFromCart(at: indexPath)
        dismiss(animated: true, completion: nil)
    }

    @objc private func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
}
