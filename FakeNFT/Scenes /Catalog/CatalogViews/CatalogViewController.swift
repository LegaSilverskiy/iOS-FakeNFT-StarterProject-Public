import UIKit
import ProgressHUD

final class CatalogViewController: UIViewController, ErrorView {
    
    
    private let presenter: CatalogPresenter
    
    // MARK: - Private UI Properties
    
    private let tableForCollectionsNft = UITableView()
    private let sortButton = UIButton()
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        self.presenter = CatalogPresenter(servicesAssembly: servicesAssembly)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view?.viewDidLoad()
        presenter.view = self
        configureUI()
        setupSortButton()
        setupTableForCollectionsNft()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWllAppear()
    }
    
    //MARK: - Public Methods
    
    func updatetable() {
        tableForCollectionsNft.reloadData()
    }
    
    
    func showProgressHud() {
        
        UIBlockingProgressHUD.show()
    }
    
    func hideProgressHud() {
        UIBlockingProgressHUD.dismiss()
    }
    //MARK: - IB Actions
    
    @objc private func sortButtonTapped() {
        showAlertController()
    }
}

//MARK: - Constraints

private extension CatalogViewController {
    
    func setupConstraints() {
        setupSortButtonConstraints()
        setupTableForCollectionsNftConstraint()
    }
    
    func showAlertController() {
        let alert = UIAlertController(title: .actionSheetTitleSorting,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let sortByName = UIAlertAction(title: .sortingOptionsByNamedNft, style: .default)
        let sortByNftCount = UIAlertAction(title: .sortingOptionsByNumberOfNFTs, style: .default)
        let cancelAction = UIAlertAction(title: .buttonsClose, style: .cancel)
        [sortByName, sortByNftCount, cancelAction].forEach { alert.addAction($0)}
        self.present(alert, animated: true)
    }
}

//MARK: - UITabvleViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getAllCatalogs()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCellForTableView.reUseIdentifier, for: indexPath) as? CustomCellForTableView else { return UITableViewCell() }
        let params = presenter.getParamsForCell(for: indexPath.row)
        cell.configure(with: params)
        cell.selectionStyle = .none
        
        return cell
    }
    
}

//MARK: - UITabvleViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationCollection = CurrentCollectionNftViewController()
        let navigation = UINavigationController(rootViewController: navigationCollection)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private Methods
private extension CatalogViewController {
    
    func configureUI() {
        setupNavigationBar()
        configureView()
        addSubviews()
        setupSortButton()
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        view.addSubview(tableForCollectionsNft)
    }
    
    func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
    }
    
    func setupSortButton() {
        sortButton.setImage(UIImage.navBarIconsSort, for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }
    
    func setupSortButtonConstraints() {
        sortButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupTableForCollectionsNft()  {
        tableForCollectionsNft.register(CustomCellForTableView.self, forCellReuseIdentifier: CustomCellForTableView.reUseIdentifier)
        tableForCollectionsNft.separatorStyle = .none
        tableForCollectionsNft.dataSource = self
        tableForCollectionsNft.delegate = self
        tableForCollectionsNft.showsVerticalScrollIndicator = false
        
    }
    
    func setupTableForCollectionsNftConstraint() {
        
        tableForCollectionsNft.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableForCollectionsNft.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableForCollectionsNft.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableForCollectionsNft.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableForCollectionsNft.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

