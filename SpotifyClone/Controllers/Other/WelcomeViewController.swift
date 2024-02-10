//
//  WelcomeViewController.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/5/24.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = WelcomeViewModel()
    
    // MARK: - Views
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "albums")
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.9
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "spotify-logo")
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Listen to millions of songs\non the go."
        label.font = .systemFont(ofSize: 32, weight: .bold)
        
        return label
    }()
    
    // MARK: - Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setUpViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Add a sign in button
        signInButton.frame = CGRect(
            x: 20,
            y: view.height - 50 - view.safeAreaInsets.bottom,
            width: view.width - 40,
            height: 50
        )
        overlayView.frame = view.bounds
        bgImageView.frame = view.bounds
        
        logoImageView.frame = CGRect(x: (view.width-120)/2, y: (view.height-300)/2, width: 120, height: 120)
        label.frame = CGRect(x: 30, y: logoImageView.bottom+30, width: view.width-60, height: 150)
    }
    
    
    // MARK: - Private Functions
    
    private func setUpViews() {
        title = "Spotify"
        view.backgroundColor = .systemGreen
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        view.addSubview(bgImageView)
        view.addSubview(overlayView)
        view.addSubview(logoImageView)
        view.addSubview(label)
        view.addSubview(signInButton)
    }
    
    private func setUpViewModel() {
        viewModel.signInCompletion = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
    }
    
    // MARK: - Action Methods
    
    @objc func didTapSignIn() {
        viewModel.signIn(navigationController: navigationController)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabVarVC = TabBarViewController()
        mainAppTabVarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabVarVC, animated: true)
    }
}
