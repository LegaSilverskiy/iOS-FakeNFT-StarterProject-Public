//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Andrey Lazarev on 16.08.2024.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    var urlString: String?

    private let webView = WKWebView()
    
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

    override func viewDidLoad() {
        super.viewDidLoad()

        configBackButton()
        setupUI()
        setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }
    
    private func configBackButton() {
        self.navigationItem.leftBarButtonItem = backButton
    }

    private func setupUI() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        tabBarController?.tabBar.isHidden = true
        
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }

    // MARK: - Actions
    @objc func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
