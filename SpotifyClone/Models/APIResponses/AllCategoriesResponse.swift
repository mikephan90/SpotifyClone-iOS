//
//  AllCategoriesResponse.swift
//  SpotifyClone
//
//  Created by Mike Phan on 2/8/24.
//

import Foundation

struct AllCategoriesResponse: Codable {
    let categories: Categories
}

struct Categories: Codable {
    let items: [Category]
}

struct Category: Codable {
    let icons: [APIImage]
    let id: String
    let name: String
}
