//
//  WelcomeViewModel.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/10/24.
//

import Foundation
import UIKit

class WelcomeViewModel {
    
    // MARK: - Properties
    
    private let authManager = AuthManger.shared
    
    var signInCompletion: ((Bool) -> Void)?
    
    // MARK: - Methods
    
    func signIn(navigationController: UINavigationController?) {
        let authViewController = AuthViewController()
        
        authViewController.completionHandler = { [weak self] success in
            self?.signInCompletion?(success)
            navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(authViewController, animated: true)
        
        func exchangeCodeForToken(code: String) {
            authManager.exchangeCodeForToken(code: code) { [weak self] success in
                self?.signInCompletion?(success)
            }
        }
    }
}
