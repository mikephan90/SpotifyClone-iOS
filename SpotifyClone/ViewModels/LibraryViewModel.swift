//
//  LibraryViewModel.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/10/24.
//

import Foundation

class LibraryViewModel {
    
    // MARK: - Properties
    
    var playlistsViewModel = LibraryPlaylistsViewModel()
    var albumsViewModel = LibraryAlbumViewModel()
    
    // MARK: - Methods
        
        func fetchData(completion: @escaping (Bool) -> Void) {
            var success = false
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            playlistsViewModel.fetchData { result in
                success = result
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            albumsViewModel.fetchData { result in
                success = result
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(success)
            }
        }
}
