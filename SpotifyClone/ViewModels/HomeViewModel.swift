//
//  HomeViewModel.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/10/24.
//

import Foundation

class HomeViewModel {
    
    // MARK: - Properties
    
    private let apiCaller = APICaller.shared
    
    // MARK: - Methods
    
    func fetchData(completion: @escaping (Result<([Album], [Playlist], [AudioTrack]), Error>) -> Void) {
        let group = DispatchGroup()
        var newAlbums: [Album] = []
        var playlists: [Playlist] = []
        var tracks: [AudioTrack] = []
        
        group.enter()
        group.enter()
//        group.enter()
        
        // New releases
        apiCaller.getNewReleases { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let response):
                newAlbums = response.albums.items
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        
        // Featured playlist
        apiCaller.getFeaturedPlaylist { result in
            defer {
                group.leave()
            }
            switch result {
            case .success(let response):
                playlists = response.playlists.items
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
//        // Recommended tracks
//        apiCaller.getRecommendedGenres { result in
//            switch result {
//            case .success(let response):
//                let genres = response.genres
//                var seeds = Set<String>()
//                while seeds.count < 5 {
//                    if let random = genres.randomElement() {
//                        seeds.insert(random)
//                    }
//                }
//                APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
//                    defer {
//                        group.leave()
//                    }
//                    switch recommendedResult {
//                    case .success(let response):
//                        tracks = response.tracks
//                    case .failure(let error):
//                        completion(.failure(error))
//                    }
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
        
        // When group queue is done execute
        group.notify(queue: .main) {
            completion(.success((newAlbums, playlists, tracks)))
        }
    }
    
}
