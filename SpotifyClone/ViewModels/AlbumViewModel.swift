//
//  AlbumViewModel.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/11/24.
//

import Foundation

class AlbumViewModel {
    
    // MARK: - Properties
    
    private let album: Album
    var viewModels = [AlbumCollectionViewCellViewModel]()
    
    // MARK: - Inits
    
    init(album: Album) {
        self.album = album
    }

    // MARK: - Methods
    func fetchData(album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        APICaller.shared.getAlbumDetails(for: album) { result in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
