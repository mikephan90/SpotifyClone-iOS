//
//  FeaturedPlaylistResponse.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/6/24.
//

import Foundation

struct FeaturedPlaylistResponse: Codable {
    let playlists: PlaylistResponse
}

struct PlaylistResponse: Codable {
    let items: [Playlist]
}

struct Playlist: Codable {
    let description: String
    let id: String
    let images: [APIImage]
    let external_urls: [String: String]
    let name: String
    let owner: User
}

struct User: Codable {
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
