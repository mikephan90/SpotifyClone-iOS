//
//  CategoryViewModel.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/11/24.
//

import Foundation

class CategoryViewModel {
    
    // MARK: - Properties
    
    private let apiCaller = APICaller.shared
    
    // MARK: - Methods
    
    func fetchData(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        apiCaller.getCategoryPlaylist(category: category) { result in
            switch result {
            case .success(let playlists):
                completion(.success(playlists))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}

