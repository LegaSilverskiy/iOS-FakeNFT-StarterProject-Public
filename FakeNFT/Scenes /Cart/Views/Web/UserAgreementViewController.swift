import UIKit
import WebKit

final class UserAgreementViewController: UIViewController {
    private var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadUserAgreement()
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
    
    private func loadUserAgreement() {
        if let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/"), 
           let webView {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.title = "Пользовательское соглашение"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .tabBarItemsTintColor
    }
    
    @objc
    private func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}
