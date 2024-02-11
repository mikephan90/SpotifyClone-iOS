//
//  PlaylistViewModel.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/11/24.
//

import Foundation

protocol PlaylistViewModelDelegate: AnyObject {
    func didRemoveTrack(at index: Int)
    func failedToRemoveTrack()
}

class PlaylistViewModel {
    
    // MARK: - Properties
    
    private let playlist: Playlist
    var viewModels: [TrackCellViewModel] = []
    weak var delegate: PlaylistViewModelDelegate?
    
    // MARK: - Inits
    
    init(playlist: Playlist) {
        self.playlist = playlist
    }
    
    // MARK: - Methods
    
    func fetchData(playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        APICaller.shared.getPlaylistDetails(for: playlist) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func removeTrack(track: AudioTrack, from playlist: Playlist, completion: @escaping (Bool) -> Void) {
        APICaller.shared.removeTrackFromPlaylist(track: track, playlist: playlist) { success in
            if success {
                completion(success)
            }
        }
    }
}
