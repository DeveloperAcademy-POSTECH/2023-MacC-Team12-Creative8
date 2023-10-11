//
//  SetlistListModel.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

// MARK: - SetlistListModel
struct SetlistListModel: Codable {
    let type: String?
    let itemsPerPage, page, total: Int?
    let setlist: [Setlist]?
}

// MARK: - Setlist
struct Setlist: Codable {
    let id, versionId: String?
    let eventDate: String?
    let lastUpdated: String?
    let artist: Artist?
    let venue: Venue?
    let sets: Sets?
    let url: String?
    let info: String?
    let tour: Tour?
}

// MARK: - Artist
struct Artist: Codable {
    let mbid, name, sortName, disambiguation: String?
    let url: String?
}

// MARK: - Sets
struct Sets: Codable {
    let setsSet: [Set]?

    enum CodingKeys: String, CodingKey {
        case setsSet = "set"
    }
}

// MARK: - Set
struct Set: Codable {
    let song: [Song]?
    let encore: Int?
    let name: String?
}

// MARK: - Song
struct Song: Codable {
    let name, info: String?
    let cover: Artist?
    let tape: Bool?
}

// MARK: - Tour
struct Tour: Codable {
    let name: String?
}

// MARK: - Venue
struct Venue: Codable {
    let id, name: String?
    let city: City?
    let url: String?
}

// MARK: - City
struct City: Codable {
    let id: String?
    let name, state: String?
    let stateCode: String?
    let coords: Coords?
    let country: Country?
}

// MARK: - Coords
struct Coords: Codable {
    let lat, long: Double?
}

// MARK: - Country
struct Country: Codable {
    let code: String?
    let name: String?
}
