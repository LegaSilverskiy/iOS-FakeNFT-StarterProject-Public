import UIKit

final class CartDeleteViewController: UIViewController {
    weak var delegate: CartPresenterDelegate?
    var indexPath: IndexPath?
    
    private let mainContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
    
        return stackView
    }()
    
    private let nftInfoContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 12
        
        return stackView
    }()
    
    private let buttonsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let nftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "nft-2")
        imageView.layer.cornerRadius = 12

        return imageView
    }()
    
    private let warningMessage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.caption2
        label.textColor = .tabBarItemsTintColor
        label.text = "Вы уверены, что хотите \nудалить объект из корзины?"
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .tabBarItemsTintColor
        button.titleLabel?.font = UIFont.bodyRegular
        
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Удалить", for: .normal)
        button.addTarget(self, action: #selector(deleteFromCart), for: .touchUpInside)
        
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.translatesAutoresizingMaskIntoConstraints = false
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
        setupContainers()
    }
    
    private func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(blurEffectView)
    }
    
    private func setupContainers() {
        view.addSubview(mainContainer)
        
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
    }
    
    @objc private func deleteFromCart() {
        guard let indexPath = indexPath else { return }
        delegate?.deleteFromCart(at: indexPath)
        dismiss(animated: true, completion: nil)
    }

    @objc private func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
}
