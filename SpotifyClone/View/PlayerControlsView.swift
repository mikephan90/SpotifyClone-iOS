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
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
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
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        // Name Label Constraints
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Subtitle Label Constraints
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Volume Slider Constraints
        NSLayoutConstraint.activate([
            volumeSlider.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            volumeSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            volumeSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            volumeSlider.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Play/Pause Button Constraints
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: volumeSlider.bottomAnchor, constant: 30),
            playPauseButton.widthAnchor.constraint(equalToConstant: 60),
            playPauseButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        // Back Button Constraints
        NSLayoutConstraint.activate([
            backButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -50),
            backButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 60),
            backButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        // Next Button Constraints
        NSLayoutConstraint.activate([
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 50),
            nextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 60),
            nextButton.heightAnchor.constraint(equalToConstant: 60)
        ])
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
