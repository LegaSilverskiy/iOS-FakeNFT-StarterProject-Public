import UIKit

final class ProfileViewController: UIViewController {
    
    let servicesAssembly: ServicesAssembly
    
    private let tableNames = ["Мои NFT", "Избранные NFT", "О разработчике"]
    
    private lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: ProfileViewController.self, action: #selector(editButtonTapped))
        button.tintColor = .tabBarItemsTintColor
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var authorName: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .headline3
        title.textColor = .textPrimary
        title.text = "Joaquin Phoenix"
        return title
    }()
    
    private lazy var authorDescription: UITextView = {
        let text = UITextView()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = .textPrimary
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let attributedString = NSAttributedString(
            string: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
            attributes: [
                .font: UIFont.caption2,
                .paragraphStyle: paragraphStyle
            ])
        text.attributedText = attributedString
        text.isEditable = false
        return text
    }()
    
    private lazy var authorImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.image = UIImage(named: "User Pic")
        return image
    }()
    
    private lazy var authorLink: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .caption1
        title.textColor = .primary
        title.text = "Joaquin Phoenix.com"
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
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = editButton
        
        view.addSubview(containerView)
        containerView.addSubview(authorName)
        containerView.addSubview(authorImage)
        containerView.addSubview(authorDescription)
        containerView.addSubview(authorLink)
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            
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
        
        authorDescription.sizeToFit()
    }
    
    @objc private func editButtonTapped() {
        
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        
        cell.title.text = tableNames[indexPath.row]
        
        return cell
    }
}
