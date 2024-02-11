//
//  CategoryCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/8/24.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CategoryCollectionViewCell"
    
    // MARK: - Views
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        
        return imageView
    }()
    
    private let labelText: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let colors: [UIColor] = [
        .systemRed,
        .systemBlue,
        .systemGreen,
        .systemOrange,
        .systemYellow,
        .systemMint,
        .systemGray,
        .systemPink,
        .systemCyan,
        .systemPurple
    ]
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(labelText)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelText.text = nil
        imageView.image = UIImage(systemName: "music.quarternote.3",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        labelText.frame = CGRect(x: 10, y: contentView.height / 2, width: contentView.width - 20, height: contentView.height / 2)
        imageView.frame = CGRect(x: contentView.width / 2, y: 10, width: contentView.width / 2, height: contentView.height / 2)
    }
    
    func configure(with viewModel: CategoryCollectionViewCellModel) {
        labelText.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkUrl, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
    
}
