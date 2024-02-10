//
//  AlbumDetailsResponse.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/7/24.
//

import Foundation

struct AlbumDetailsResponse: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let release_date: String
    let total_tracks: Int
    let tracks: TracksResponse
}
