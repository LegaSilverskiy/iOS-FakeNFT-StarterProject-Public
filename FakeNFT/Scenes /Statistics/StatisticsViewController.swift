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
        
        setSortButton()
        setRatingTable()
    }
    
    private func setSortButton () {
        sortButton = UIButton.systemButton(with: .navBarIconSort ?? UIImage(), target: self, action: #selector(self.sortButtonPressed))
        sortButton.tintColor = .tabBarItemsTintColor
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sortButton)
        
        sortButton.heightAnchor.constraint(equalToConstant: 42).isActive = true
        sortButton.widthAnchor.constraint(equalToConstant: 42).isActive = true
        sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9).isActive = true
        sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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
        
        ratingTable.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20).isActive = true
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

