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
        ∏
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false

        // Sign In Button Constraints
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Overlay View Constraints
        NSLayoutConstraint.activate([
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Background Image View Constraints
        NSLayoutConstraint.activate([
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Logo Image View Constraints
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90), // Adjust constant as needed
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120)
        ])

        // Label Constraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            label.heightAnchor.constraint(equalToConstant: 150)
        ])
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
