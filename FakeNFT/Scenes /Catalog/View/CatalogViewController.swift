import UIKit

final class CatalogViewController: UIViewController {
    
    
    // MARK: - PRIVATE PROPERTIES
    let servicesAssembly: ServicesAssembly
    
    //MARK: - UI PROPERTIES
    
    let tableForCollectionsNft = UITableView()
    let filterButton = UIButton()
    
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
        configureView()
        setupNavigationBar()
        addSubviews()
        setupFilterButton()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(tableForCollectionsNft)
    }
    
    //MARK: - FILTER BUTTON
    
    private func setupFilterButton() {
        
    }
    
    private func setupFilterButtonConstraints() {
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //TODO: запилить констрейнты для фильтров
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
    }
    
}

//MARK: - CONSTRAINTS

extension CatalogViewController {
    
    private func setupConstraints() {
        setupTableForCollectionsNftConstraint()
    }
}
