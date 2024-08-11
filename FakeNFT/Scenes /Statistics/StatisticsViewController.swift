import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Private Properties
    private let ratingTableRowHeight = 88.0
    
    private var presenter: StatisticsPresenter
    private var sortButton = UIButton()
    private var ratingTable = UITableView()
    
    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly) {
        
        self.presenter = StatisticsPresenter(servicesAssembly: servicesAssembly)
                
        super.init(nibName: nil, bundle: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        
        setUI()
    }
    
    // MARK: - Public Methods
    
    // MARK: - IBAction
    @objc private func sortButtonPressed() {
        presenter.sortButtonPressed()
    }
    
    // MARK: - Private Methods
    private func setUI() {
        
        view.backgroundColor = .systemBackground

        setNavBarButtons()
        setRatingTable()
    }
    
    private func setNavBarButtons () {

        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .tabBarItemsTintColor
        navigationItem.backBarButtonItem = backItem
        
        let navBarSortButton = UIBarButtonItem(
            image: .navBarIconSort,
            style: .plain,
            target: self,
            action: #selector(sortButtonPressed)
        )
        
        navBarSortButton.tintColor = .tabBarItemsTintColor
        
        self.navigationItem.rightBarButtonItem = navBarSortButton
    }
    
    private func setRatingTable() {
        ratingTable.register(RatingTableCell.self, forCellReuseIdentifier: "ratingCell")
        ratingTable.delegate = self
        ratingTable.dataSource = self
        ratingTable.backgroundColor = .systemBackground
        ratingTable.separatorStyle = .none
        ratingTable.isScrollEnabled = true
        ratingTable.showsVerticalScrollIndicator = false
        ratingTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ratingTable)
        
        ratingTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        ratingTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        ratingTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        ratingTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
}

// MARK: - UITableViewDataSource
extension StatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getRatingMembersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as? RatingTableCell {
            
            let params = presenter.getParams(for: indexPath.row)
            cell.configure(with: params)
            
            return cell
        }
        
        debugPrint("@@@ StatisticsViewController: Ошибка подготовки ячейки для таблицы рейтинга.")
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ratingTableRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        presenter.switchToProfile(for: indexPath.row)
    }
}

