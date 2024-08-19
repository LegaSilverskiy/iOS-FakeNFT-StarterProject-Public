import UIKit
import ProgressHUD

final class CatalogViewController: UIViewController, ErrorView, LoadingView {
    
    //MARK: - PRESENTER
    var presenter: CatalogPresenter
    
    // MARK: - SERVICES ASSEMBLY
    
    
    //MARK: - ACTIVITY_INDICATOR
    internal lazy var activityIndicator = UIActivityIndicatorView()
    //MARK: - UI PROPERTIES
    
    let tableForCollectionsNft = UITableView()
    lazy var sortButton = UIButton()
    
    //MARK: - INIT
    init(servicesAssembly: ServicesAssembly) {
        self.presenter = CatalogPresenter(servicesAssembly: servicesAssembly)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - VIEW LIFE CIRCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        presenter.loadCatalogs()
        configureUI()
        setupSortButton()
        setupTableForCollectionsNft()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWllAppear()
    }
    

    
    func updatetable() {
        tableForCollectionsNft.reloadData()
    }
    
    //MARK: - PROGRESS_HUD
    func showProgressHud() {
        ProgressHUD.show()
    }
    
    func hideProgressHud() {
        ProgressHUD.dismiss()
    }
    
    //MARK: - NAVIGATION BAR
    
    private func setupNavigationBar() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
    }
    
    //MARK: - ACTIONS
    
    @objc private func sortButtonTapped() {
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
        setupSortButtonConstraints()
        setupTableForCollectionsNftConstraint()
    }
}


extension CatalogViewController: CustomCellForTableViewDelegate {
    func avx(_ cell: CustomCellForTableView) {
        
    }
    
    private func configCell(for cell: CustomCellForTableView, with indexPath: IndexPath) {
        cell.delegate = self
    }
}

    //MARK: - UI_TABLE_VIEW_DATA_SOURCE

extension CatalogViewController: UITableViewDataSource {
    //TODO: Сделать расчет колличества ячеек после получения доступа к АПИ
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getAllCatalogs()
    }
    //TODO: Заполнить данными после получения АПИ
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustomCellForTableView.reUseIdentifier, for: indexPath) as? CustomCellForTableView {
            let params = presenter.getParamsForCell(for: indexPath.row)
            cell.configure(with: params)
            return cell
        }
        debugPrint("@@@ StatisticsViewController: Ошибка подготовки ячейки для таблицы рейтинга.")
        return UITableViewCell()
    }
    
}

    //MARK: - UI_TABLE_VIEW_DELEGATE
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationCollection = CurrentCollectionNftViewController()
        let navigation = UINavigationController(rootViewController: navigationCollection)
        present(navigation, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension CatalogViewController {
    // MARK: - CONFIGURE UI
    
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
    
    //MARK: - SORT BUTTON
    func setupSortButton() {
        sortButton.setImage(UIImage.navBarIconsSort, for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
    }
    
    func setupSortButtonConstraints() {
        sortButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - TABLE VIEW WITH COLLECTIONS NFT
    func setupTableForCollectionsNft()  {
        tableForCollectionsNft.register(CustomCellForTableView.self, forCellReuseIdentifier: CustomCellForTableView.reUseIdentifier)
        tableForCollectionsNft.separatorStyle = .none
        tableForCollectionsNft.dataSource = self
        tableForCollectionsNft.delegate = self
    }
    
    func setupTableForCollectionsNftConstraint() {
        
        tableForCollectionsNft.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableForCollectionsNft.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableForCollectionsNft.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableForCollectionsNft.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableForCollectionsNft.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
}

