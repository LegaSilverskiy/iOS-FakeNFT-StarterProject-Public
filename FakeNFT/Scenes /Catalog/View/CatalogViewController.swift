import UIKit

final class CatalogViewController: UIViewController {
    
    
    // MARK: - PRIVATE PROPERTIES
    let servicesAssembly: ServicesAssembly
    
    //MARK: - UI PROPERTIES
    
    let tableForCollectionsNft = UITableView()
    let filterButton = UIButton()
    
    //    let testNftButton = UIButton()
    
    
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
        setupTableForCollectionsNft()
        setupConstraints()
    }
    
    // MARK: - CONFIGURE UI
    
    private func configureUI() {
        configureView()
        addSubviews()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(tableForCollectionsNft)
    }
    
    // MARK: - TABLE VIEW WITH COLLECTIONS NFT
    private func setupTableForCollectionsNft() {
        
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
        
    }
    
}

    //MARK: - CONSTRAINTS

extension CatalogViewController {
    
    private func setupConstraints() {
        setupTableForCollectionsNftConstraint()
    }
}
