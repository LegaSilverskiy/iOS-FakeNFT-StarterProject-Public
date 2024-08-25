//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 10.08.2024.
//
import UIKit

protocol UserCardViewProtocol: AnyObject {
    func updateUserImage(with url: URL)
    func switchToUserNFTCollectionVC(userNfts: [String], servisesAssembly: ServicesAssembly)
}

final class UserCardViewController: UIViewController, UserCardViewProtocol {

    // MARK: - Private Properties
    private let presenter: UserCardPresenterProtocol

    private var showNFTsButtonTitleLabel: UILabel?

    private lazy var avatarImageView = {
        let avatarImageView = UIImageView(image: UIImage.tabBarIconsProfile?.withTintColor(.avatarStubTintColor))
        avatarImageView.backgroundColor = .segmentInactive
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.layer.masksToBounds = true
        avatarImageView.contentMode = .scaleAspectFill

        return avatarImageView
    }()

    private lazy var nameLabel = {
        let nameLabel = UILabel()
        nameLabel.font = .headline3
        nameLabel.textAlignment = .left
        nameLabel.textColor = .tabBarItemsTintColor

        return nameLabel
    }()

    private lazy var descriptionLabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .caption2
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = .tabBarItemsTintColor
        descriptionLabel.numberOfLines = 0

        return descriptionLabel
    }()

    private lazy var userSiteButton = {
        let userSiteButton = UIButton()
        userSiteButton.addTarget(self, action: #selector(self.userSiteButtonPressed), for: .touchUpInside)
        userSiteButton.backgroundColor = .systemBackground
        userSiteButton.setTitle(.showUserSite, for: .normal)
        userSiteButton.titleLabel?.font = .caption1
        userSiteButton.setTitleColor(.tabBarItemsTintColor, for: .normal)
        userSiteButton.layer.borderWidth = 1
        userSiteButton.layer.borderColor = UIColor.tabBarItemsTintColor.cgColor
        userSiteButton.layer.masksToBounds = true
        userSiteButton.layer.cornerRadius = 16

        return userSiteButton
    }()

    private lazy var showNFTsButton = {
        let showNFTsButton = UIButton()
        showNFTsButton.addTarget(self, action: #selector(self.showNFTsButtonPressed), for: .touchUpInside)

        let titleLabel = UILabel()
        titleLabel.font = .bodyBold
        titleLabel.textAlignment = .left
        titleLabel.textColor = .tabBarItemsTintColor
        self.showNFTsButtonTitleLabel = titleLabel

        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
        chevronImageView.tintColor = .tabBarItemsTintColor

        [titleLabel, chevronImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            showNFTsButton.addSubview($0)
        }

        titleLabel.centerYAnchor.constraint(equalTo: showNFTsButton.centerYAnchor).isActive = true
        chevronImageView.centerYAnchor.constraint(equalTo: showNFTsButton.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: showNFTsButton.leadingAnchor).isActive = true
        chevronImageView.trailingAnchor.constraint(equalTo: showNFTsButton.trailingAnchor).isActive = true

        return showNFTsButton
    }()

    // MARK: - Initializers
    init(presenter: UserCardPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarButtons()
        setUI()
    }

    // MARK: - Public Methods
    func updateUserImage(with url: URL) {
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage.tabBarIconsProfile?.withTintColor(.avatarStubTintColor)
        )
    }

    func switchToUserNFTCollectionVC(userNfts: [String], servisesAssembly: ServicesAssembly) {
        let assembler = UserNftCollectionAssembler(userNfts: userNfts, servisesAssembly: servisesAssembly)
        let viewController  = assembler.build()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    // MARK: - IBAction
    @objc private func userSiteButtonPressed() {
        // TODO: - Задача на третий модуль
    }

    @objc private func showNFTsButtonPressed() {
        presenter.showNFTsButtonPressed()
    }

    // MARK: - Private Methods
    private func setNavBarButtons () {
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .tabBarItemsTintColor
        navigationItem.backBarButtonItem = backItem
    }

    private func setUI() {
        view.backgroundColor = .systemBackground

        setElements()
        setConstraints()
    }

    private func setElements() {
        [avatarImageView,
         nameLabel,
         descriptionLabel,
         userSiteButton,
         showNFTsButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }

        presenter.updateAvatar()
        nameLabel.text = self.presenter.getUserName()
        descriptionLabel.text = self.presenter.getUserDescription()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3

        descriptionLabel.attributedText = NSAttributedString(
            string: self.presenter.getUserDescription(),
            attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )

        showNFTsButtonTitleLabel?.text = String(format: .userCardShowNFTs, self.presenter.getNFTcount())
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),

            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),

            userSiteButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            userSiteButton.heightAnchor.constraint(equalToConstant: 40),
            userSiteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userSiteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            showNFTsButton.topAnchor.constraint(equalTo: userSiteButton.bottomAnchor, constant: 40),
            showNFTsButton.heightAnchor.constraint(equalToConstant: 54),
            showNFTsButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            showNFTsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
