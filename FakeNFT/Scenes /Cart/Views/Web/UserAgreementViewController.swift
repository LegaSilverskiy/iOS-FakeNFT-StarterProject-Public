import UIKit
import WebKit

final class UserAgreementViewController: UIViewController {
    private var webView: WKWebView?
    private let presenter: UserAgreementPresenter
    
    init(presenter: UserAgreementPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    private func setupWebView() {
        webView = WKWebView(frame: .zero)
        
        guard let webView else { return }
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .tabBarItemsTintColor
    }
    
    @objc
    private func backButtonPressed() {
        presenter.backButtonPressed()
    }
}

extension UserAgreementViewController: UserAgreementView {
    func loadUserAgreement(with request: URLRequest) {
        webView?.load(request)
    }
    
    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
    
    func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
