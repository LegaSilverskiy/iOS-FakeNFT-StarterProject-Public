import UIKit

protocol CartSuccessPaymentDelegate: AnyObject {
    func clearCart()
}

final class CartSuccessPaymentController: UIViewController {
    weak var delegate: CartSuccessPaymentDelegate?

    private let mainContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        return stackView
    }()

    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let message: UILabel = {
        let label = UILabel()
        label.font = UIFont.headline3
        label.textColor = .tabBarItemsTintColor
        label.text = .cartSuccessPayment
        label.textAlignment = .center
        label.numberOfLines = 2

        return label
    }()

    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .tabBarItemsTintColor

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        delegate?.clearCart()
    }

    private func setupUI() {
        view.backgroundColor = .textOnPrimary
        setupViews()
    }

    private func setupViews() {
        setupContainers()
        setupImage()
        setupButton()
    }

    private func setupContainers() {
        view.addSubview(mainContainer)
        mainContainer.addArrangedSubview(image)
        mainContainer.addArrangedSubview(message)

        NSLayoutConstraint.activate([
            mainContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            mainContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36)
        ])
    }

    private func setupImage() {
        image.image = UIImage(named: "cart.success")

        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: 278),
            image.heightAnchor.constraint(equalToConstant: 278)
        ])
    }

    private func setupButton() {
        view.addSubview(button)

        button.setTitle(.cartBackToCart, for: .normal)
        button.addTarget(self, action: #selector(returnToCart), for: .touchUpInside)
        button.titleLabel?.font = UIFont.bodyBold
        button.setTitleColor(.textOnPrimary, for: .normal)
        button.layer.cornerRadius = 16

        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc
    private func returnToCart() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}
