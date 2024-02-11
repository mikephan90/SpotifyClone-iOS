//
//  ProfileViewModel.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/11/24.
//

import Foundation

class ProfileViewModel {
    
    // MARK: - Properties
    private var apiCaller = APICaller.shared
    
    // MARK: - Methods
    
    func fetchProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        apiCaller.getCurrentUserProfile { result in
            completion(result)
        }
    }
}
