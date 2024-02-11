//
//  LibraryPlaylistsViewModel.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/10/24.
//

import Foundation

class LibraryPlaylistsViewModel {
    
    // MARK: - Properties
    
    var playlists: [Playlist] = []
    let apiCaller = APICaller.shared
    
    var noPlaylistsText: String {
        return "You don't have any playlist yet"
    }
    
    var isPlaylistEmpty: Bool {
        return playlists.isEmpty
    }
    
    // MARK: - Methods
    
    func fetchData(completion: @escaping (Bool) -> Void) {
        apiCaller.getCurrentUserPlaylists { result in
            switch result {
            case .success(let playlists):
                self.playlists = playlists
                completion(true)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) {
        apiCaller.createPlaylist(with: name) { success in
            DispatchQueue.main.async {
                if success {
                    HapticsManager.shared.vibrate(for: .success)
                } else {
                    HapticsManager.shared.vibrate(for: .error)
                    print("Failed to create playlist")
                }
                completion(success)
            }
        }
    }
}
