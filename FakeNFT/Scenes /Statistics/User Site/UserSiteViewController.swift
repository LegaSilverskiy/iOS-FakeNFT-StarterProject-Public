//
//  UserSiteViewController.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 25.08.2024.
//
import UIKit
import WebKit

protocol UserSiteViewProtocol: AnyObject {
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
    func loadSite(url: URL)
}

final class UserSiteViewController: UIViewController, UserSiteViewProtocol {

    // MARK: - Private Properties
    private let presenter: UserSitePresenterProtocol
    private var estimatedProgressObservation: NSKeyValueObservation?
    private let webView =  WKWebView()
    private lazy var progressView = {
        var progressView = UIProgressView()
        progressView.progressTintColor = .tabBarItemsTintColor
        return progressView
    }()

    // MARK: - Initializers
    init(presenter: UserSitePresenterProtocol) {
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
        setEstimatedProgressObservation()
        setUI()
        presenter.viewDidLoad()
    }

    // MARK: - Public Methods
    func loadSite(url: URL) {
        webView.load(URLRequest(url: url))
    }

    func setProgressValue(_ newValue: Float) {
        progressView.setProgress(Float(newValue), animated: true)
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    // MARK: - Private Methods
    private func setNavBarButtons () {
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .tabBarItemsTintColor
        navigationItem.backBarButtonItem = backItem
    }

    private func setEstimatedProgressObservation() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: {[weak self] _, _ in
                 guard let presenter = self?.presenter,
                       let estimatedProgress = self?.webView.estimatedProgress else {
                     return
                 }
                 presenter.didUpdateProgressValue(estimatedProgress)
             }
        )
    }

    private func setUI() {
        [webView, progressView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
