//
//  PlaylistCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/7/24.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Propeties
    
    static let identifier = "PlaylistCollectionViewCell"
    
    // MARK: - Views
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.width
 
        // Image
        playlistCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playlistCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playlistCoverImageView.widthAnchor.constraint(equalToConstant: imageSize),
            playlistCoverImageView.heightAnchor.constraint(equalToConstant: imageSize)
        ])
        
        // Title
        playlistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playlistNameLabel.topAnchor.constraint(equalTo: playlistCoverImageView.bottomAnchor, constant: 10),
            playlistNameLabel.centerXAnchor.constraint(equalTo: playlistCoverImageView.centerXAnchor)
        ])
        
        // Creator
        creatorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            creatorNameLabel.topAnchor.constraint(equalTo: playlistNameLabel.bottomAnchor),
            creatorNameLabel.centerXAnchor.constraint(equalTo: playlistCoverImageView.centerXAnchor)
        ])
    }
    
    // Called to prepare when we reuse cell. Set to nil to prevent state issues with these components
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
        playlistCoverImageView.image = nil
    }
    
    // Configure Cell with viewModel info
    func configure(with viewModel: PlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkUrl, completed: nil)
    }
}
