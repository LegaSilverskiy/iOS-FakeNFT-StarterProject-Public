//
//  CurrentCollectionNftViewController.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/19/24.
//

import UIKit
import Kingfisher
import ProgressHUD

final class CurrentCollectionNftViewController: UIViewController {

    // MARK: - Private properties
    private let servicesAssembly: ServicesAssembly
    private var presenter: CurrentCollectionNftPresenter

    // MARK: - UI properties
    private lazy var coverImage = UIImageView()
    private lazy var titleLabel = UILabel()
    private lazy var authorLabel = UILabel()
    private lazy var authorButton = UIButton()
    private lazy var descriptionLabel = UILabel()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(customBackAction)
        )
        button.tintColor = .black
        return button
    }()

    // MARK: - Initializers
    init(servicesAssembly: ServicesAssembly, presenter: CurrentCollectionNftPresenter) {
        self.servicesAssembly = servicesAssembly
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getNftCollection()
        presenter.loadData()
        configureUI()
        tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Extensions
extension CurrentCollectionNftViewController {
    func setupData(
        name: String,
        cover: URL,
        author: String,
        description: String
    ) {
        coverImage.kf.setImage(with: cover)
        titleLabel.text = name
        authorButton.setTitle(author, for: .normal)
        descriptionLabel.text = description
    }

    func updateCell(indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }

    func reloadData() {
        collectionView.reloadData()
    }

    func showLoading() {
        UIBlockingProgressHUD.show()
    }

    func hideLoading() {
        UIBlockingProgressHUD.dismiss()
    }

    func showErrorAlert() {
        let alert = UIAlertController(
            title: NSLocalizedString("error.title", comment: ""),
            message: NSLocalizedString("error.network", comment: ""),
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(
            title: NSLocalizedString("buttons.cancel", comment: ""),
            style: .cancel
        )

        let repeatAction = UIAlertAction(
            title: NSLocalizedString("buttons.repeat", comment: ""),
            style: .default
        ) { [weak self] _ in
            self?.presenter.getNftCollection()
        }

        [cancelAction,
         repeatAction].forEach {
            alert.addAction($0)
        }

        alert.preferredAction = cancelAction
        present(alert, animated: true)
    }
}

extension CurrentCollectionNftViewController {
    func updateOrder(for indexPath: IndexPath) {
        presenter.updateOrderState(for: indexPath)
    }

    func updateLike(for indexPath: IndexPath) {
        presenter.updateLikeState(for: indexPath)
    }
}

// MARK: - UICollectionViewDataSource
extension CurrentCollectionNftViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.nfts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NftCollectionViewCell.identifier, for: indexPath
        ) as? NftCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.prepareForReuse()

        let model = presenter.getCellModel(for: indexPath)
        cell.configureCell(with: model)
        cell.indexPath = indexPath
        cell.view = self
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CurrentCollectionNftViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(
            width: 108,
            height: 192
        )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        9
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }
}

// MARK: - Private methods
private extension CurrentCollectionNftViewController {

    func configureUI() {
        addSubViews()
        setupConstraints()
        configTitleLabel()
        configImageView()
        configureAuthorLabel()
        configAuthorButton()
        configDescriptionLabel()
        configCollectionView()
        configBackButton()
        view.backgroundColor = .systemBackground
    }

    func configBackButton() {
        self.navigationItem.leftBarButtonItem = backButton
    }

    func configTitleLabel() {
        titleLabel.textColor = .mainTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    }

    func configImageView() {
        coverImage.contentMode = .scaleAspectFill
        coverImage.clipsToBounds = true
        coverImage.layer.cornerRadius = 12
        coverImage.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    func configureAuthorLabel() {
        authorLabel.text = "Автор коллекции:"
        authorLabel.textColor = .mainTextColor
        authorLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }

    func configAuthorButton() {
        authorButton.setTitleColor(UIColor.blueColorForLinks, for: .normal)
        authorButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        authorButton.addTarget(self, action: #selector(didTapAuthorButton), for: .touchUpInside)
    }

    func configDescriptionLabel() {
        descriptionLabel.textAlignment = .left
        descriptionLabel.sizeToFit()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.mainTextColor
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }

    func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NftCollectionViewCell.self, forCellWithReuseIdentifier: NftCollectionViewCell.identifier)
    }
    func addSubViews() {
        [coverImage,
         titleLabel,
         authorLabel,
         authorButton,
         descriptionLabel,
         collectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: 310),

            titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 28),

            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 13),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.widthAnchor.constraint(equalToConstant: 112),
            authorLabel.heightAnchor.constraint(equalToConstant: 18),

            authorButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            authorButton.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 4),
            authorButton.heightAnchor.constraint(equalToConstant: 28),

            descriptionLabel.topAnchor.constraint(equalTo: authorButton.bottomAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),

            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Actions
    @objc func didTapAuthorButton() {
        let url = presenter.getAuthorURL()
        guard let url = url else { return }
        let webView = WebViewForAuthorViewController(url: url)
        navigationController?.pushViewController(webView, animated: true)
    }

    @objc func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }

}
