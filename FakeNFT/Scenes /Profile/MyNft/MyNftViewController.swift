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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Private

    private func loadPresenter() {
        hideUIElements()
        presenter.viewDidLoad()
    }

    private func hideUIElements() {
        sortButton.image = nil
        sortButton.isEnabled = false
        ProgressHUD.show()
        view.isHidden = true
    }

    private func setupUI() {
        sortButton = UIBarButtonItem(
            image: UIImage(named: "Sort"),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        sortButton.tintColor = .tabBarItemsTintColor
        navigationItem.rightBarButtonItem = sortButton

        tabBarController?.tabBar.isHidden = true

        title = "Мои NFT"
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        createBackButton()
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

    private func createBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.tintColor = .black

        let backBarButtonItem = UIBarButtonItem(customView: backButton)

        navigationItem.leftBarButtonItem = backBarButtonItem

        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }

    @objc private func backTapped() {
        presenter.didTapExit()
        navigationController?.popViewController(animated: true)
    }

    @objc private func sortButtonTapped() {

        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)

        for option in SortKeys.allCases {

            alertController.addAction(UIAlertAction(title: option.rawValue, style: .default) { _ in
                self.presenter.sortNfts(by: option)
                UserDefaults.standard.set(option.rawValue, forKey: "selectedSortKey")
            })
        }

        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - MyNftViewProtocol

extension MyNftViewController: MyNftViewProtocol {

    func showUIElements() {
        sortButton.image = UIImage(named: "Sort")
        sortButton.isEnabled = true
        tableView.reloadData()
        ProgressHUD.dismiss()
        view.isHidden = false
    }

    func showEmptyNfts() {
        sortButton.image = nil
        tableView.isHidden = true
        emptyLabel.isHidden = false
    }
}

// MARK: - UITableView

extension MyNftViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.nfts.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNftTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MyNftTableViewCell else {
            return UITableViewCell()
        }

        cell.delegate = self
        cell.configureCell(model: presenter.nfts[indexPath.section])
        return cell
    }
}

extension MyNftViewController: UITableViewDelegate { }

extension MyNftViewController: MyNftTableViewCellDelegate {
    func didTapLike(needToAdd: Bool, id: String) {
        presenter.didTapLike(needToAdd: needToAdd, id: id)
        tableView.reloadData()
    }
}
