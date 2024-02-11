//
//  ProfileHeaderView.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/11/24.
//

import Foundation
import UIKit
import SDWebImage

class ProfileHeaderView: UIView {
    
    // MARK: - Views
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Configure
    
    func configure(with imageUrl: String?) {
        guard let urlString = imageUrl,
              let url = URL(string: urlString) else {
            profileImageView.image = UIImage(named: "default_profile_image")
            return
        }
        
        profileImageView.sd_setImage(with: url, completed: nil)
    }
}
