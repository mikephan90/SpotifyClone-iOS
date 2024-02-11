//
//  RecommendedTrackCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/7/24.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    
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
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: -  UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumCoverImageView.frame = CGRect(
            x: 5,
            y: 2,
            width: contentView.height - 4,
            height: contentView.height - 4)
        trackNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: 0,
            width: contentView.width - albumCoverImageView.right - 15,
            height: contentView.height / 2)
        artistNameLabel.frame = CGRect(
            x: albumCoverImageView.right + 10,
            y: contentView.height / 2,
            width: contentView.width - albumCoverImageView.right - 15,
            height: contentView.height / 2)
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
