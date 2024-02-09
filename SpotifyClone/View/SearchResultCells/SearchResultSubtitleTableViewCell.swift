//
//  SearchResultSubtitleTableViewCell.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/8/24.
//

import UIKit
import SDWebImage

class SearchResultSubtitleTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "SearchResultSubtitleTableViewCell"
    
    private let labelText: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabelText: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(labelText)
        contentView.addSubview(subtitleLabelText)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 10
        let labelHeight = contentView.height / 2
        
        iconImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)
        labelText.frame = CGRect(
            x: iconImageView.right + 10,
            y: 0,
            width: contentView.width - iconImageView.right - 15,
            height: contentView.height
        )
        subtitleLabelText.frame = CGRect(
            x: iconImageView.right + 10,
            y: labelHeight,
            width: contentView.width - iconImageView.right - 15,
            height: labelHeight
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        labelText.text = nil
        subtitleLabelText.text = nil
    }
    
    // MARK: - Configure
    func configure(with viewModel: SearchResultSubtitleTableViewModel) {
        labelText.text = viewModel.title
        subtitleLabelText.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
    }
}
