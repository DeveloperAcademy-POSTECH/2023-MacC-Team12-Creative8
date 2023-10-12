//
//  ArtistListModel.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

// MARK: - ArtistListModel
struct ArtistListModel: Codable {
    let created: String?
    let count: Int?
    let offset: Int?
    let artists: [MusicBrainzArtist]?
}

// MARK: - Artist
struct MusicBrainzArtist: Codable {
    let id: String?
    let name: String?
    let sortName: String?
    let country: String?
    let area: Area?
    let beginArea: Area?
    let aliases: [Alias]?
}

// MARK: - Alias
struct Alias: Codable {
    let sortName: String?
    let typeID: String?
    let name: String?
    let locale: String?
    let type: String?
    let primary: Bool?
}

// MARK: - Area
struct Area: Codable {
    let id: String?
    let type: String?
    let typeID: String?
    let name: String?
    let sortName: String?
}
