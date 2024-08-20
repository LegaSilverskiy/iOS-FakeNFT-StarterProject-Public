//
//  MyNftViewController.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 18.08.2024.
//

import UIKit
import ProgressHUD

protocol MyNftViewProtocol: AnyObject {
    func showUIElements()
    func showEmptyNfts()
}

final class MyNftViewController: UIViewController {
    
    private let presenter: MyNftPresenterProtocol
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyNftTableViewCell.self, forCellReuseIdentifier: MyNftTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var emptyLabel = {
        let emptyText = UILabel()
        emptyText.translatesAutoresizingMaskIntoConstraints = false
        emptyText.text = "У Вас ещё нет NFT"
        emptyText.font = .bodyBold
        emptyText.textColor = .textPrimary
        emptyText.isHidden = true
        return emptyText
    }()
    
    private var sortButton = UIBarButtonItem()
    
    private let sortOptions = ["По цене", "По рейтингу", "По названию"]
    
    init(presenter: MyNftPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPresenter()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    func showUIElements() {
        sortButton.target = self
        tableView.reloadData()
        ProgressHUD.dismiss()
        view.isHidden = false
    }
    
    func loadPresenter() {
        hideUIElements()
        presenter.viewDidLoad()
    }
    
    func showEmptyNfts() {
        sortButton.image = nil
        tableView.isHidden = true
        emptyLabel.isHidden = false
    }
    
    // MARK: - Private
    
    private func hideUIElements() {
        sortButton.image = nil
        ProgressHUD.show()
        view.isHidden = true
    }
    
    private func setupUI() {
        
        sortButton = UIBarButtonItem(image: UIImage(named: "Sort"), style: .plain, target: self, action: #selector(sortButtonTapped))
        sortButton.tintColor = .tabBarItemsTintColor
        navigationItem.rightBarButtonItem = sortButton
        
        title = "Мои NFT"
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        createBackbutton()
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             
            emptyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func createBackbutton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = .black

        let backBarButtonItem = UIBarButtonItem(customView: backButton)

        navigationItem.leftBarButtonItem = backBarButtonItem

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func sortButtonTapped() {
        
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        for option in sortOptions {
            
            alertController.addAction(UIAlertAction(title: option, style: .default) { _ in
                self.presenter.sortNfts(by: option)
            })
        }
        
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
}

extension MyNftViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.nfts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNftTableViewCell.reuseIdentifier, for: indexPath) as? MyNftTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(model: presenter.nfts[indexPath.section])
        return cell
    }
}

extension MyNftViewController: UITableViewDelegate { }

extension MyNftViewController: MyNftViewProtocol {
    func reloadTable() {
        tableView.reloadData()
    }
}
