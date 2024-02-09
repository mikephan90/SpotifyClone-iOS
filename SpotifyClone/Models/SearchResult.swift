//
//  SearchResult.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/8/24.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
