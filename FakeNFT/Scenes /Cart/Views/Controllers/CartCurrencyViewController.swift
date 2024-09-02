import UIKit

protocol CartCurrencyView: AnyObject {
    func reloadData()
    func selectCurrency(at indexPath: IndexPath)
    func navigateToUserAgreement()
    func showFailedPaymentAlert()
    func showSuccessFlow()
    func showHud()
    func hideHud()
}

final class CartCurrencyViewController: UIViewController {
    private weak var cartViewController: CartViewController?
    private var presenter: CartCurrencyPresenterProtocol

    private let currencyCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(
            CurrencyCollectionViewCell.self,
            forCellWithReuseIdentifier: CurrencyCollectionViewCell.reuseIdentifier
        )

        return collectionView
    }()

    private let footerPanel: UIView = {
        let view = UIView()
        return view
    }()

    private let currencyInfoContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4

        return stackView
    }()

    private let userAgreementTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .tabBarItemsTintColor
        label.text = .cartUserAgreementFirstPart

        return label
    }()

    private let userAgreementLink: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .yaBlue
        label.text = .cartUserAgreementSecondPart
        label.isUserInteractionEnabled = true

        return label
    }()

    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .tabBarItemsTintColor
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    init(presenter: CartCurrencyPresenterProtocol, viewController: CartViewController) {
        self.presenter = presenter
        self.cartViewController = viewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        setupUI()
        presenter.viewDidLoad()
    }

    private func setupUI() {
        navigationItem.title = .cartChoosePaymentMethod
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: "chevron.backward"
            ),
            style: .plain,
            target: self,
            action: #selector(
                backButtonPressed
            )
        )
        navigationItem.leftBarButtonItem?.tintColor = .tabBarItemsTintColor
        view.backgroundColor = .textOnPrimary

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userAgreementTapped))
        userAgreementLink.addGestureRecognizer(tapGesture)

        setupViews()
    }

    private func setupViews() {
        [currencyCollectionView,
         footerPanel,
         currencyInfoContainer,
         payButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        setupCurrencyCollectionView()
        setupFooterPanel()
        setupContainers()
        setupPayButton()
    }

    private func setupCurrencyCollectionView() {
        currencyCollectionView.dataSource = self
        currencyCollectionView.delegate = self
        currencyCollectionView.allowsMultipleSelection = false
        currencyCollectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

        NSLayoutConstraint.activate([
            currencyCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currencyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currencyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currencyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupFooterPanel() {
        footerPanel.backgroundColor = .segmentInactive
        footerPanel.layer.cornerRadius = 12
        footerPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        NSLayoutConstraint.activate([
            footerPanel.heightAnchor.constraint(equalToConstant: 186),
            footerPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupContainers() {
        currencyInfoContainer.addArrangedSubview(userAgreementTitle)
        currencyInfoContainer.addArrangedSubview(userAgreementLink)

        NSLayoutConstraint.activate([
            currencyInfoContainer.topAnchor.constraint(equalTo: footerPanel.topAnchor, constant: 16),
            currencyInfoContainer.leadingAnchor.constraint(equalTo: footerPanel.leadingAnchor, constant: 16),
            currencyInfoContainer.trailingAnchor.constraint(equalTo: footerPanel.trailingAnchor, constant: -16)
        ])
    }

    private func setupPayButton() {
        payButton.setTitle(.buttonsPay, for: .normal)
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        payButton.titleLabel?.font = UIFont.bodyBold
        payButton.setTitleColor(.textOnPrimary, for: .normal)
        payButton.layer.cornerRadius = 16
        payButton.isEnabled = false
        payButton.backgroundColor = .tabBarItemsTintColor.withAlphaComponent(0.2)

        NSLayoutConstraint.activate([
            payButton.heightAnchor.constraint(equalToConstant: 60),
            payButton.topAnchor.constraint(equalTo: currencyInfoContainer.bottomAnchor, constant: 20),
            payButton.leadingAnchor.constraint(equalTo: footerPanel.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: footerPanel.trailingAnchor, constant: -16)
        ])

        updatePayButtonState()
    }

    private func updatePayButtonState() {
        let isSelected = presenter.isCurrencySelected()
        payButton.isEnabled = isSelected
        payButton.backgroundColor = isSelected ? .tabBarItemsTintColor : .tabBarItemsTintColor.withAlphaComponent(0.2)
    }

    @objc
    private func backButtonPressed() {
        dismiss(animated: true)
    }

    @objc
    private func userAgreementTapped() {
        presenter.userAgreementTapped()
    }

    @objc
    private func payButtonTapped() {
        presenter.processPayment()
    }
}

extension CartCurrencyViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        presenter.getCurrencies().count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CurrencyCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CurrencyCollectionViewCell else {
            return UICollectionViewCell()
        }

        let currency = presenter.getCurrencies()[indexPath.row]
        cell.configCell(for: currency)

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let padding: CGFloat = 7
        let totalPadding = padding * 5.6
        let width = (view.frame.width - totalPadding) / 2

        return CGSize(width: width, height: 46)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
         7
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        7
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectCurrency(at: indexPath)
        updatePayButtonState()
    }
}

extension CartCurrencyViewController: CartCurrencyView {
    func showHud() {
        UIBlockingProgressHUD.show()
    }

    func hideHud() {
        UIBlockingProgressHUD.dismiss()
    }

    func showSuccessFlow() {
        let viewController = presenter.getSuccessFlow()
        viewController.delegate = cartViewController

        present(viewController, animated: true)
    }

    func showFailedPaymentAlert() {
        let actions = presenter.getFailedPaymentAlertActions()

        let alert = UIAlertController().createAlert(
            for: CartAlertModel(title: .cartErrorPayment, message: nil),
            action: actions,
            style: .alert
        )

        present(alert, animated: true)
    }

    func navigateToUserAgreement() {
        let userAgreementVC = UserAgreementViewController(presenter: UserAgreementPresenter())
        let navController = UINavigationController(rootViewController: userAgreementVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }

    func selectCurrency(at indexPath: IndexPath) {
        currencyCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
    }

    func reloadData() {
        currencyCollectionView.reloadData()
    }
}
