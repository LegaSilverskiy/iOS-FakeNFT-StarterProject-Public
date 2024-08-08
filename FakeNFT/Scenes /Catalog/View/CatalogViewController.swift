import UIKit

final class CatalogViewController: UIViewController {
    
    
    // MARK: - PRIVATE PROPERTIES
    let servicesAssembly: ServicesAssembly
    
    //MARK: - UI PROPERTIES
    
    let tableForCollectionsNft = UITableView()
    let sortButton = UIButton()
    let navigationBar = UINavigationBar()
    
    //MARK: - INIT
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - VIEW LIFE CIRCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupSortButton()
        setupTableForCollectionsNft()
        setupConstraints()
    }
    
    // MARK: - CONFIGURE UI
    
    private func configureUI() {
        setupNavigationBar()
        configureView()
        addSubviews()
        setupSortButton()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(tableForCollectionsNft)
        view.addSubview(navigationBar)
        navigationBar.addSubview(sortButton)
    }
    
    //MARK: - SORT BUTTON
    
    private func setupSortButton() {
        sortButton.setImage(UIImage(named: "navBar.sort"), for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }
    
    private func setupSortButtonConstraints() {
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: navigationBar.topAnchor),
            sortButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -9),
            sortButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            sortButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    // MARK: - TABLE VIEW WITH COLLECTIONS NFT
    private func setupTableForCollectionsNft() {
        //TODO: сделать описание таблицы. Зарегать ее и т.д.
    }
    
    private func setupTableForCollectionsNftConstraint() {
        
        tableForCollectionsNft.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableForCollectionsNft.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableForCollectionsNft.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableForCollectionsNft.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableForCollectionsNft.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    //MARK: - NAVIGATION BAR
    
    private func setupNavigationBar() {
        navigationBar.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
    }
    
    private func setupNavigationBarConstraints() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    //MARK: - ACTIONS
    
    @objc func sortButtonTapped() {
        showAlertController()
    }
    
    //MARK: - UIALERTCONTROLLER
    
    private func showAlertController() {
        let alert = UIAlertController(title: "Сортировка",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let sortByName = UIAlertAction(title: "Сортировка по имени", style: .default)
        let sortByNftCount = UIAlertAction(title: "По количеству NFT", style: .default)
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        [sortByName, sortByNftCount, cancelAction].forEach { alert.addAction($0)}
        self.present(alert, animated: true)
    }
    
}

    //MARK: - CONSTRAINTS

extension CatalogViewController {
    
    private func setupConstraints() {
        setupNavigationBarConstraints()
        setupSortButtonConstraints()
        setupTableForCollectionsNftConstraint()
    }
}
