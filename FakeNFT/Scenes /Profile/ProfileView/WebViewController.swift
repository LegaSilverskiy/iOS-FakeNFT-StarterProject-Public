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

    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.frame = view.frame
        
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
