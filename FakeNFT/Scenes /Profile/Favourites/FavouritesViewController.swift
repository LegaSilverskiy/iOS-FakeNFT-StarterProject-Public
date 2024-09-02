//
//  FavouritesViewController.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 22.08.2024.
//

import UIKit
import ProgressHUD

protocol FavouritesViewProtocol: AnyObject {
    func showUIElements()
    func showLoading()
    func showEmptyFavouriteNfts()
}

final class FavouritesViewController: UIViewController {

    private let presenter: FavouritesPresenterProtocol

    private lazy var collectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(
            FavouritesCollectionViewCell.self,
            forCellWithReuseIdentifier: FavouritesCollectionViewCell.reuseIdentifier
        )
        return collection
    }()

    private lazy var emptyLabel = {
        let emptyText = UILabel()
        emptyText.translatesAutoresizingMaskIntoConstraints = false
        emptyText.text = "У Вас ещё нет избранных NFT"
        emptyText.font = .bodyBold
        emptyText.textColor = .textPrimary
        emptyText.isHidden = true
        return emptyText
    }()

    init(presenter: FavouritesPresenterProtocol) {
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
        ProgressHUD.show()
        view.isHidden = true
    }

    private func setupUI() {
        tabBarController?.tabBar.isHidden = true

        title = "Избранные NFT"
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        createBackButton()
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)

    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

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
}

// MARK: - FavouritesViewProtocol

extension FavouritesViewController: FavouritesViewProtocol {

    func showUIElements() {
        collectionView.reloadData()
        ProgressHUD.dismiss()
        view.isHidden = false
    }

    func showEmptyFavouriteNfts() {
        collectionView.isHidden = true
        emptyLabel.isHidden = false
    }

    func showLoading() {
        ProgressHUD.show()
    }
}

extension FavouritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.favouriteNfts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavouritesCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? FavouritesCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.delegate = self
        cell.configureCell(model: presenter.favouriteNfts[indexPath.row])

        return cell
    }
}

extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let availableWidth = collectionView.bounds.width - 32 - 7
        let cellWidth =  availableWidth / CGFloat(2)
        return CGSize(width: cellWidth,
                      height: 80)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        7
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        20
    }
}

extension FavouritesViewController: FavouriteCellDelegate {
    func didTapLike(id: String) {
        presenter.didTapLike(id: id)
    }
}
