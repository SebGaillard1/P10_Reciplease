//
//  DirectionWebViewController.swift
//  P10_Reciplease
//
//  Created by Sebastien Gaillard on 15/01/2022.
//

import UIKit
import WebKit

class DirectionWebViewController: UIViewController {
    //MARK: - Properties
    var webView: WKWebView!
    var url: String!

    //MARK: - View life cycle
    override func loadView() {
        super.loadView()
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: url) else { return }
        webView.load(URLRequest(url: url))
    }
}

extension DirectionWebViewController: WKNavigationDelegate {
    
}
