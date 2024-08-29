//
//  WebViewForAuthor.swift
//  FakeNFT
//
//  Created by Олег Серебрянский on 8/28/24.
//

import UIKit
import WebKit

final class WebViewForAuthorViewController: UIViewController {
    
    //MARK: - Private properties
    private var url: URL?
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
    
    //MARK: - UI Components
    private lazy var webView = WKWebView()
    
    // MARK: - Initializers
    init(url: URL?) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        loadWebView()
    }
    
    //MARK: - Private methods
    private func configBackButton() {
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func loadWebView() {
        guard let url = url else { return }
        webView.load(URLRequest(url: url))
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        addViews()
        layoutViews()
        configBackButton()
    }
    
    private func addViews() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    private func layoutViews() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }
    
    //MARK: - Actions
    @objc func customBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
