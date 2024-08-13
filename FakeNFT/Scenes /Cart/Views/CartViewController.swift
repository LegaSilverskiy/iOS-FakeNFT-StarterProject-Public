import UIKit

final class CartViewController: UIViewController {
    
    private let presenter: CartPresenter
    
    private let nftsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    init(servicesAssembly: ServicesAssembly) {
        self.presenter = CartPresenter(servicesAssembly: servicesAssembly)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupViews()
        
    }
    
    private func setupViews() {
        setupTableView()
        setupSortButton()
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
        nftsTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        view.addSubview(nftsTableView)
        NSLayoutConstraint.activate([
            nftsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            nftsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nftsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nftsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func sortButtonPressed() {
        
    }
}
