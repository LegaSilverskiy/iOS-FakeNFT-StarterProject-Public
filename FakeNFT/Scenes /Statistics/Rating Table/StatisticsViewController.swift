import UIKit

protocol StatisticsViewProtocol: AnyObject, ErrorView {
    func showSortMenu()
    func showLoading()
    func hideLoading()
    func updateTable()
    func switchToUserCard(userInfo: User, servisesAssembly: ServicesAssembly)
    func showError(_ model: ErrorModel)
}

final class StatisticsViewController: UIViewController, StatisticsViewProtocol {
    
    // MARK: - Private Properties
    private let presenter: StatisticsPresenterProtocol
    private let sortButton = UIButton()
    private let ratingTable = UITableView()
    private let ratingTableRowHeight = 88.0
    
    // MARK: - Initializers
    init(presenter: StatisticsPresenterProtocol) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        presenter.viewWllAppear()
    }
    
    // MARK: - Public Methods
    func showLoading() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoading() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func showSortMenu() {
        ActionSheetPresenter.show(actionSheet: .actionSheetTitleSorting, 
                                  with: [.name, .rating],
                                  on: self,
                                  delegate: presenter
        )
    }
    
    func switchToUserCard(userInfo: User, servisesAssembly: ServicesAssembly) {
        
        let assembler = UserCardAssembler(userInfo: userInfo, servisesAssembly: servisesAssembly)
        let vc  = assembler.build()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateTable() {
        ratingTable.reloadData()
    }
    
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
        ratingTable.register(RatingTableCell.self, forCellReuseIdentifier: RatingTableCell.reuseIdentifier)
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
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: RatingTableCell.reuseIdentifier, for: indexPath) as? RatingTableCell {
            
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
