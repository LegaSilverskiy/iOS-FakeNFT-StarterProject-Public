import UIKit

final class CartViewController: UIViewController {
    
    private let presenter: CartPresenter
    
    private let nftsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private let footerPanel: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 24
        
        return stackView
    }()
    
    private let totalPriceContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        
        return stackView
    }()
    
    private let nftCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.caption1
        label.textColor = .tabBarItemsTintColor
        
        return label
    }()
    
    private let nftTotalPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bodyBold
        label.textColor = .yaGreen

        return label
    }()
    
    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .tabBarItemsTintColor
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let emptyCartState: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bodyBold
        label.textColor = .tabBarItemsTintColor
        label.text = "Корзина пуста"

        return label
    }()
    
    init(presenter: CartPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        presenter.loadNfts()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    private func setupViews() {
        setupSortButton()
    }
    
    private func setupDefaultState() {
        presenter.getNftsCount() == 0 ? setupEmptyCartInfo() : setupTableView()
    }
    
    private func setupEmptyCartInfo() {
        footerPanel.isHidden = true
        view.addSubview(emptyCartState)
        NSLayoutConstraint.activate([
            emptyCartState.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCartState.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupSortButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "navBarItem.sort"), style: .plain, target: self, action: #selector(sortButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .tabBarItemsTintColor
        navigationItem.rightBarButtonItem?.width = 44
    }
    
    private func setupTableView() {
        nftsTableView.delegate = self
        nftsTableView.dataSource = self
        
        nftsTableView.separatorStyle = .none
        nftsTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 82, right: 0)
        nftsTableView.delaysContentTouches = false

        view.addSubview(nftsTableView)
        NSLayoutConstraint.activate([
            nftsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            nftsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupFooterPanel()
        setupFooterPanelContainers()
        setupPayButton()
        
        footerPanel.isHidden = false
    }
    
    private func setupFooterPanel() {
        view.addSubview(footerPanel)
        
        footerPanel.backgroundColor = .segmentInactive
        footerPanel.layer.cornerRadius = 12
        footerPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        NSLayoutConstraint.activate([
            footerPanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerPanel.heightAnchor.constraint(equalToConstant: 76)
        ])
    }
    
    private func setupFooterPanelContainers() {
        footerPanel.addArrangedSubview(totalPriceContainer)
        footerPanel.addArrangedSubview(payButton)
        
        totalPriceContainer.addArrangedSubview(nftCount)
        totalPriceContainer.addArrangedSubview(nftTotalPrice)
        
        NSLayoutConstraint.activate([
            totalPriceContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupPayButton() {
        payButton.setTitle("К оплате", for: .normal)
        payButton.titleLabel?.font = UIFont.bodyBold
        payButton.setTitleColor(.textOnPrimary, for: .normal)
        payButton.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            payButton.heightAnchor.constraint(equalToConstant: 44),
            payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc
    private func sortButtonPressed() {
        let actions = presenter.showSortOptions()
        let alert = UIAlertController().showSortActionSheet(for: AlertModel(title: "Сортировка", message: nil), action: actions)
        
        present(alert, animated: true)
    }
}

extension CartViewController: CartView {
    func deleteFromCart(at indexPath: IndexPath) {
        presenter.deleteFromCart(at: indexPath)
    }
    
    func presentBlurredScreen(with indexPath: IndexPath, imageURL: String) {
        let blurredVC = CartDeleteViewController(
            delegate: self,
            indexPath: indexPath,
            imageURL: imageURL
        )
        blurredVC.modalPresentationStyle = .overFullScreen
        blurredVC.modalTransitionStyle = .crossDissolve
        
        present(blurredVC, animated: true, completion: nil)
    }
    
    func reloadData() {
        setupDefaultState()
        nftCount.text = "\(presenter.getNftsCount()) NFT"
        nftTotalPrice.text = presenter.formattedTotalPrice()
        nftsTableView.reloadData()
    }
    
    func deleteRows(at indexPath: IndexPath) {
        nftsTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func showHud() {
        UIBlockingProgressHUD.show()
    }
    
    func hideHud() {
        UIBlockingProgressHUD.dismiss()
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNftsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseIdentifier, for: indexPath) as? CartTableViewCell else { return UITableViewCell()
        }
        
        let cartNftModel = presenter.getNft(at: indexPath)
        
        cell.delegate = self
        cell.selectionStyle = .none
        cell.configCell(with: cartNftModel, at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func didTapButton(in cell: CartTableViewCell, at indexPath: IndexPath, with image: String) {
        presentBlurredScreen(with: indexPath, imageURL: image)
    }
}


