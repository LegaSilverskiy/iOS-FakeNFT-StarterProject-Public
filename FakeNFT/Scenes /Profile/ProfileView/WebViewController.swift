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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        tabBarController?.tabBar.isHidden = true
        webView.frame = view.frame
        
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }
}
