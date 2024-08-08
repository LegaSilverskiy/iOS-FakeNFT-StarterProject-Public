import UIKit

final class CatalogViewController: UIViewController {
    
    
    // MARK: - PRIVATE PROPERTIES
    let servicesAssembly: ServicesAssembly
    
    //MARK: - UI PROPERTIES
    
    let tableForCollectionsNft = UITableView()
    let filterButton = UIButton()
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
        setupFilterButton()
        setupTableForCollectionsNft()
        setupConstraints()
    }
    
    // MARK: - CONFIGURE UI
    
    private func configureUI() {
        setupNavigationBar()
        configureView()
        addSubviews()
        setupFilterButton()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(tableForCollectionsNft)
        view.addSubview(navigationBar)
        navigationBar.addSubview(filterButton)
    }
    
    //MARK: - FILTER BUTTON
    
    private func setupFilterButton() {
        filterButton.setImage(UIImage(named: "navBar.filter"), for: .normal)
    }
    
    private func setupFilterButtonConstraints() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: navigationBar.topAnchor),
            filterButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -9),
            filterButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 42)
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
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
    
}

//MARK: - CONSTRAINTS

extension CatalogViewController {
    
    private func setupConstraints() {
        setupNavigationBarConstraints()
        setupFilterButtonConstraints()
        setupTableForCollectionsNftConstraint()
    }
}
