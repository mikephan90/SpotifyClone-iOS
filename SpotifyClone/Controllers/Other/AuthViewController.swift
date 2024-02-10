//
//  AuthViewController.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/5/24.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    
    // MARK: - Properties
    
    public var completionHandler: ((Bool) -> Void)?
    private let viewModel = AuthViewModel()
    
    // Create a webview for authentication
    private let webView: WKWebView = {
        
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        // Configures webview page
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        
        webView.navigationDelegate = self
        
        if let url = viewModel.signInUrl() {
            // Open into webview
            webView.load(URLRequest(url: url))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Make entire page the webview
        webView.frame = view.bounds
    }
}

extension AuthViewController: WKNavigationDelegate {
    // Because we added observants to the navigation delegate for webview
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      
        
        guard let url = webView.url,
              let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { 
                  $0.name == "code"
              })?.value else {
            return
        }
        webView.isHidden = true

        AuthManger.shared.exchangeCodeForToken(code: code) { [weak self] success in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
}
