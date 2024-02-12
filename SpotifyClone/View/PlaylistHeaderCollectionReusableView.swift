//
//  PlaylistHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/7/24.
//

import UIKit

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

class PlaylistHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "PlaylistHeaderCollectionReusableView"
    weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    // MARK: -  Views
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    private let playlistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        button.backgroundColor = .systemGreen
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(playlistImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(playAllButton)
        playlistImageView.layer.masksToBounds = true
        playlistImageView.layer.cornerRadius = 10
        playAllButton.addTarget(self, action: #selector(didTapPlayAll), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Methods
    
    @objc private func didTapPlayAll() {
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = 200
        
        playlistImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        playAllButton.translatesAutoresizingMaskIntoConstraints = false

        // Playlist Image View Constraints
        NSLayoutConstraint.activate([
            playlistImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            playlistImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            playlistImageView.widthAnchor.constraint(equalToConstant: imageSize),
            playlistImageView.heightAnchor.constraint(equalToConstant: imageSize)
        ])

        // Name Label Constraints
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: playlistImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])

        // Description Label Constraints
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])

        // Owner Label Constraints
        NSLayoutConstraint.activate([
            ownerLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),
            ownerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            ownerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])

        // Play All Button Constraints
        NSLayoutConstraint.activate([
            playAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            playAllButton.topAnchor.constraint(equalTo: playlistImageView.bottomAnchor, constant: 20),
            playAllButton.widthAnchor.constraint(equalToConstant: 60),
            playAllButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configure(with viewModel: PlaylistHeaderViewViewModel) {
        nameLabel.text = viewModel.name
        ownerLabel.text = viewModel.ownerName
        descriptionLabel.text = viewModel.description
        playlistImageView.sd_setImage(with: viewModel.artworkUrl, placeholderImage: UIImage(systemName: "photo") ,completed: nil)
    }
}
