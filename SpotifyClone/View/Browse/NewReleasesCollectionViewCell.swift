//
//  NewReleasesCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/7/24.
//

import UIKit
import SDWebImage

class NewReleasesCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewReleasesCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.largeContentTitle = "New Releases"
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        let albumLabelSize = albumNameLabel.sizeThatFits(
            CGSize(width: contentView.width - imageSize - 10,
                   height: contentView.height - 10
                  )
            )
        
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        let albumLabelHeight = min(60, albumLabelSize.height)
        
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        let infoOffset = albumCoverImageView.right + 10
        
        albumNameLabel.frame = CGRect(x: infoOffset,
                                      y: 5,
                                      width: albumLabelSize.width,
                                      height: albumLabelHeight
        )
        
        artistNameLabel.frame = CGRect(x: infoOffset,
                                       y: albumNameLabel.bottom,
                                       width: contentView.width - albumCoverImageView.right - 5,
                                       height: 30
        )
        
        numberOfTracksLabel.frame = CGRect(x: infoOffset,
                                           y: contentView.bottom - 44,
                                           width: contentView.width,
                                           height: 44
        )

    }
    
    // Called to prepare when we reuse cell. Set to nil to prevent state issues with these components
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    // Configure Cell with viewModel info
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkUrl, completed: nil)
    }
}
