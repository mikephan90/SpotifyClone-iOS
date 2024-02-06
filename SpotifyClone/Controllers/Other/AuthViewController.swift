//
//  AuthViewController.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/5/24.
//

import UIKit
import WebKit

class AuthViewController: UIViewController {
    
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
    
    // Communicates from webView to app
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        
        webView.navigationDelegate = self
        
        guard let url = AuthManger.shared.signInUrl else {
            return
        }
        
        // Open into webview
        webView.load(URLRequest(url: url))
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Make entire page the webview
        webView.frame = view.bounds
    }
    
    // Because we added observants to the navigation delegate for webview
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        
        // if url has parameter for code, take it out
        // Exchnage code for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code" })?.value else {
            return
        }
        webView.isHidden = true

        AuthManger.shared.exchangeCodeForToken(code: code) { [weak self] success in
            // Dispatch on to main thread
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
                self?.completionHandler?(success)
            }
        }
    }
}

extension AuthViewController: WKNavigationDelegate {
    
}
