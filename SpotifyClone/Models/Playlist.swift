//
//  Playlist.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/5/24.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let id: String
    let images: [APIImage]
    let external_urls: [String: String]
    let name: String
    let owner: User
}
