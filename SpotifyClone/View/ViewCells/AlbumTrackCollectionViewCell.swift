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

        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            trackNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            trackNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            trackNameLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
        ])

        NSLayoutConstraint.activate([
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
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
