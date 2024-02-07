//
//  RecommendationsResponse.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/7/24.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
