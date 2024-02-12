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
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelText.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
   
        labelText.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            labelText.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            labelText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }
    
    func configure(with viewModel: CategoryCollectionViewCellModel) {
        labelText.text = viewModel.title
        contentView.backgroundColor = colors.randomElement()
    }
}
