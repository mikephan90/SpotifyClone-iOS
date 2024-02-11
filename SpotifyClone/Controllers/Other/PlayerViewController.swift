//
//  PlayerViewController.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/5/24.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapNext()
    func didTapBack()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    
    weak var delegate: PlayerViewControllerDelegate?

    // MARK: - Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlsView = PlayerControlsView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        
        controlsView.delegate = self
        
        configureBarButtons()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height / 2)
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom + 10,
            width: view.width - 20,
            height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15
        )
    }
    
    // MARK: - Functions
    
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageUrl, completed: nil)
        controlsView.configure(with: PlayerControlsViewModel(
            title: dataSource?.songName,
            subtitle: dataSource?.subtitle)
        )
    }
    
    func refreshUI() {
        configure()
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapAction() {
       
    }
}

extension PlayerViewController: PlayerControlViewDelegate {
    func playerControllerView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControllerViewDidTapPlayPause(_ playerControlView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func playerControllerViewDidTapNextButton(_ playerControlView: PlayerControlsView) {
        delegate?.didTapNext()
    }
    
    func playerControllerViewDidTapBackButton(_ playerControlView: PlayerControlsView) {
        delegate?.didTapBack()
    }
}
