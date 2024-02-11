//
//  LibraryAlbumViewModel.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/10/24.
//

import Foundation

class LibraryAlbumViewModel {
    
    // MARK: - Properties
    
    var albums: [Album] = []
    let apiCaller = APICaller.shared
    
    // MARK: - Methods
    
    func fetchData(completion: @escaping (Bool) -> Void) {
        apiCaller.getCurrentUserAlbums { result in
                switch result {
                case .success(let albums):
                    self.albums = albums
                    completion(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
            }
    }
}
