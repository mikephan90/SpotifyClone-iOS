//
//  ProfileTableViewCell.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/11/24.
//

import Foundation
import UIKit

class ProfileTableViewCell: UITableViewCell {
    static let identifier = "ProfileTableViewCell"
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            // Customize cell appearance
            textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            textLabel?.textColor = UIColor.label
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func configure(with detail: String) {
            textLabel?.text = detail
        }
}
