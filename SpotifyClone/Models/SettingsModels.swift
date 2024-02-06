//
//  SettingsModels.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/6/24.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
