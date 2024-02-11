//
//  AlbumTrackCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/8/24.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "AlbumTrackCollectionViewCell"
    
    // MARK: - Views
    
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
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackNameLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.width - 15,
            height: contentView.height / 2)
        artistNameLabel.frame = CGRect(
            x: 10,
            y: contentView.height / 2,
            width: contentView.width - 15,
            height: contentView.height / 2)
    }
    
    // Called to prepare when we reuse cell. Set to nil to prevent state issues with these components
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    // Configure Cell with viewModel info
    func configure(with viewModel: AlbumCollectionViewCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}
