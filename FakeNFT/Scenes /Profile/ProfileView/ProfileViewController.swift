import UIKit
import ProgressHUD

protocol ProfileViewProtocol: AnyObject {
    func showUIElements()
    func showAlert()
    func adjustTextViewHeight(_ textView: UITextView)
    var authorName: UILabel { get set }
    var authorDescription: UITextView { get set }
    var authorLink: UILabel { get set }
    var authorImage: UIImageView { get set }
}

protocol SendTextDelegate: AnyObject {
    func loadPresenter()
}

final class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    lazy var authorName: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .headline3
        title.textColor = .textPrimary
        return title
    }()
    
    lazy var authorDescription: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .textPrimary
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let attributedString = NSAttributedString(
            string: "",
            attributes: [
                .font: UIFont.caption2,
                .paragraphStyle: paragraphStyle
            ])
        text.attributedText = attributedString
        text.isEditable = false
        return text
    }()
    
    lazy var authorImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 35
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    lazy var authorLink: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .caption1
        title.textColor = .primary
        title.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(webviewTapped))
        title.addGestureRecognizer(tapGesture)
        return title
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 54
        tableView.separatorStyle = .none
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let presenter: ProfilePresenterProtocol
    private var textViewHeightConstraint: NSLayoutConstraint?
    private var containerViewHeightConstraint: NSLayoutConstraint?
    
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupConstraints()
        
        loadPresenter()
    }
    
    func showAlert() {
        let alertController = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось загрузить профиль",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.loadPresenter()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func updateConstraintsForTextView(_ textView: UITextView, _ estimatedSize: CGSize) {
        textViewHeightConstraint?.isActive = false
        containerViewHeightConstraint?.isActive = false
        
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: estimatedSize.height + 8)
        textViewHeightConstraint?.isActive = true

        containerViewHeightConstraint = containerView.heightAnchor.constraint(
            equalToConstant: estimatedSize.height + 137
        )
        containerViewHeightConstraint?.isActive = true
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        let editButton = UIBarButtonItem(
            image: UIImage(named: "Edit"),
            style: .plain,
            target: self,
            action: #selector(
                editButtonTapped
            )
        )
        editButton.tintColor = .tabBarItemsTintColor
        navigationItem.rightBarButtonItem = editButton
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        containerView.addSubview(authorName)
        containerView.addSubview(authorImage)
        containerView.addSubview(authorDescription)
        containerView.addSubview(authorLink)
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        textViewHeightConstraint = authorDescription.heightAnchor.constraint(lessThanOrEqualToConstant: 80)
        textViewHeightConstraint?.isActive = true
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        containerViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            authorName.leadingAnchor.constraint(equalTo: authorImage.trailingAnchor, constant: 16),
            authorName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            authorName.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 21),
            authorName.centerYAnchor.constraint(equalTo: authorName.centerYAnchor),
            
            authorDescription.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            authorDescription.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18),
            authorDescription.topAnchor.constraint(equalTo: authorImage.bottomAnchor, constant: 20),
            authorDescription.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
            
            authorImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            authorImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            authorImage.heightAnchor.constraint(equalToConstant: 70),
            authorImage.widthAnchor.constraint(equalToConstant: 70),
            
            authorLink.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            authorLink.topAnchor.constraint(equalTo: authorDescription.bottomAnchor, constant: 8),
            
            tableView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 162)
        ])
        
    }
    
    private func hideUIElements() {
        navigationController?.isNavigationBarHidden = true
        ProgressHUD.show()
        view.isHidden = true
    }
    
    func showUIElements() {
        navigationController?.isNavigationBarHidden = false
        tableView.reloadData()
        ProgressHUD.dismiss()
        view.isHidden = false
    }
    
    func adjustTextViewHeight(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude)
        var estimatedSize = textView.sizeThatFits(size)
        
        if estimatedSize.width == 0 {
            estimatedSize.height = 0
        }
        
        var frame = textView.frame
        frame.size.height = estimatedSize.height
        textView.frame = frame
        
        updateConstraintsForTextView(textView, estimatedSize)
    }
    
    private func routeToMyNft() -> UIViewController {
        guard let profile = presenter.profile else { return UIViewController()}
        
        let networkClient = DefaultNetworkClient()
        let nftService = MyNftService(networkClient: networkClient)
        let presenter = MyNftPresenter(nftService: nftService, nftString: profile.nfts)
        let myNftViewController = MyNftViewController(presenter: presenter)
        presenter.view = myNftViewController
        return myNftViewController
    }
    
    @objc private func editButtonTapped() {
        let networkClient = DefaultNetworkClient()
        let networkService = EditProfileService(networkClient: networkClient)
        let presenter = EditProfilePresenter(profileService: networkService, profile: presenter.profile!)
        let editProfileViewController = EditProfileViewController(presenter: presenter)
        presenter.view = editProfileViewController
        presenter.delegate = self
        let editNavController = UINavigationController(rootViewController: editProfileViewController)
        present(editNavController, animated: true)
    }
    
    @objc private func webviewTapped() {
        let webViewVC = WebViewController()
        webViewVC.urlString = authorLink.text
        navigationController?.pushViewController(webViewVC, animated: true)
    }
}

// MARK: - TableView

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 0 {
            let myNftViewController = routeToMyNft()
            navigationController?.pushViewController(myNftViewController, animated: true)
        } else if indexPath.row == 2 {
            webviewTapped()
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.tableNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        
        cell.title.text = presenter.tableNames[indexPath.row]
        
        if let nftsCount = presenter.profile?.nfts.count {
            if indexPath.row == 0 {
                cell.title.text = "\(presenter.tableNames[indexPath.row]) (\(nftsCount))"
            }
        }
        
        return cell
    }
}

// MARK: - SendTextDelegate

extension ProfileViewController: SendTextDelegate {
    
    func loadPresenter() {
        hideUIElements()
        presenter.viewDidLoad()
    }
}

