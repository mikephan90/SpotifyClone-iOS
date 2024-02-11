//
//  PlayerControlsView.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/8/24.
//

import Foundation
import UIKit

protocol PlayerControlViewDelegate: AnyObject {
    func playerControllerViewDidTapPlayPause(_ playerControlView: PlayerControlsView)
    func playerControllerViewDidTapNextButton(_ playerControlView: PlayerControlsView)
    func playerControllerViewDidTapBackButton(_ playerControlView: PlayerControlsView)
    func playerControllerView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}

final class PlayerControlsView: UIView {
    
    // MARK: - Properties
    
    private var isPlaying = true
    
    weak var delegate: PlayerControlViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "This is my song"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Drake"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        
        let image = UIImage(
            systemName: "backward.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30,
                weight: .regular)
        )
        
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        
        let image = UIImage(
            systemName: "forward.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30,
                weight: .regular)
        )
        
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        
        let image = UIImage(
            systemName: "pause",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30,
                weight: .regular)
        )
        
        button.setImage(image, for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(volumeSlider)
        addSubview(backButton)
        addSubview(nextButton)
        addSubview(playPauseButton)
        
        
        volumeSlider.addTarget(self, action: #selector(didSlideSlider), for: .valueChanged)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        subtitleLabel.frame = CGRect(x: 0, y: nameLabel.bottom, width: width, height: 50)
        
        volumeSlider.frame = CGRect(x: 10, y: subtitleLabel.bottom + 20, width: width - 20, height: 44)
        
        let buttonSize: CGFloat = 60
        playPauseButton.frame = CGRect(
            x: (width - buttonSize) / 2,
            y: volumeSlider.bottom + 30,
            width: buttonSize,
            height: buttonSize
        )
        
        backButton.frame = CGRect(x: playPauseButton.left - 50 - buttonSize, y: playPauseButton.top, width: buttonSize, height: buttonSize)
        nextButton.frame = CGRect(x: playPauseButton.right + 50, y: playPauseButton.top, width: buttonSize, height: buttonSize)
    }
    
    // MARK: - Functions
    
    func configure(with viewModel: PlayerControlsViewModel) {
        nameLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
    
    @objc private func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControllerView(self, didSlideSlider: value)
    }
    
    @objc private func didTapBack() {
        delegate?.playerControllerViewDidTapBackButton(self)
    }
    
    @objc private func didTapNext() {
        delegate?.playerControllerViewDidTapNextButton(self)
    }
    
    @objc private func didTapPlayPause() {
        self.isPlaying = !isPlaying
        delegate?.playerControllerViewDidTapPlayPause(self)
        
        let play = UIImage(
            systemName: "play.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        )
        let pause = UIImage(
            systemName: "pause",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .regular)
        )
            
        // Update Icon
        playPauseButton.setImage(isPlaying ? pause : play, for: .normal)
    }
}
