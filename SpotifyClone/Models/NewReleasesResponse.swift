//
//  NewReleasesResponse.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/6/24.
//

import Foundation

struct NewReleasesResponse: Codable {
    let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
    let items: [Album]
}
