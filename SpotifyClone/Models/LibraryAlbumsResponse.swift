//
//  LibraryAlbumsResponse.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/10/24.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let album: Album
    let added_at: String
}

