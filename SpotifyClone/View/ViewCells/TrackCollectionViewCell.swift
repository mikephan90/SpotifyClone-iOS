//
//  RecommendedTrackCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/7/24.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Propeties
    
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    // MARK: - Views
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.largeContentTitle = "New Releases"
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: -  UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let stackView = UIStackView()
        
        contentView.addSubview(stackView)
        
        stackView.addSubview(trackNameLabel)
        stackView.addSubview(artistNameLabel)
        
        // Album Cover
        albumCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumCoverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            albumCoverImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            albumCoverImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        
        // StackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        
        stackView.addArrangedSubview(trackNameLabel)
        stackView.addArrangedSubview(artistNameLabel)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    // Called to prepare when we reuse cell. Set to nil to prevent state issues with these components
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    // Configure Cell with viewModel info
    func configure(with viewModel: TrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumCoverImageView.sd_setImage(with: viewModel.artworkUrl, completed: nil)
    }
}
