import UIKit

final class CartCurrencyViewController: UIViewController {
    private let currencyCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CurrencyCollectionViewCell.self, forCellWithReuseIdentifier: CurrencyCollectionViewCell.reuseIdentifier)
        
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
        label.text = "Совершая покупку, вы соглашаетесь с условиями"
        
        return label
    }()
    
    private let userAgreementLink: UILabel = {
        let label = UILabel()
        label.font = UIFont.caption2
        label.textColor = .yaBlue
        label.text = "Пользовательского соглашения"
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .tabBarItemsTintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "Выберите способ оплаты"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonPressed))
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
        payButton.setTitle("Оплатить", for: .normal)
        payButton.titleLabel?.font = UIFont.bodyBold
        payButton.setTitleColor(.textOnPrimary, for: .normal)
        payButton.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            payButton.heightAnchor.constraint(equalToConstant: 60),
            payButton.topAnchor.constraint(equalTo: currencyInfoContainer.bottomAnchor, constant: 20),
            payButton.leadingAnchor.constraint(equalTo: footerPanel.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: footerPanel.trailingAnchor, constant: -16)
        ])
    }
    
    @objc
    private func backButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc
    private func userAgreementTapped() {
        let userAgreementVC = UserAgreementViewController()
        let navController = UINavigationController(rootViewController: userAgreementVC)
        navController.modalPresentationStyle = .fullScreen
        
        present(navController, animated: true, completion: nil)
    }
    
}

extension CartCurrencyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCollectionViewCell.reuseIdentifier, for: indexPath) as? CurrencyCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .segmentInactive
        cell.layer.cornerRadius = 12
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 7
        let totalPadding = padding * 5.6
        let width = (view.frame.width - totalPadding) / 2

        return CGSize(width: width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
}

