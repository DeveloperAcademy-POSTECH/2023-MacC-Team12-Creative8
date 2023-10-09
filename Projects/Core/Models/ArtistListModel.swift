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
    let count, offset: Int?
    let artists: [MusicBrainzArtist]?
}

// MARK: - Artist
struct MusicBrainzArtist: Codable {
    let id, type, typeID: String?
    let score: Int?
    let genderID, name, sortName, gender: String?
    let country: String?
    let area, beginArea: Area?
    let isnis: [String]?
    let lifeSpan: ArtistLifeSpan?
    let aliases: [Alias]?
    let tags: [Tag]?
    let disambiguation: String?
    let endArea: Area?
    let ipis: [String]?
}

// MARK: - Alias
struct Alias: Codable {
    let sortName, typeID, name: String?
    let locale, type: String?
    let primary: Bool?
    let beginDate, endDate: JSONNull?
}

// MARK: - Area
struct Area: Codable {
    let id, type, typeID, name: String?
    let sortName: String?
    let lifeSpan: AreaLifeSpan?
}

// MARK: - AreaLifeSpan
struct AreaLifeSpan: Codable {
    let ended: JSONNull?
}

// MARK: - ArtistLifeSpan
struct ArtistLifeSpan: Codable {
    let begin: String?
    let ended: Bool?
    let end: String?
}

// MARK: - Tag
struct Tag: Codable {
    let count: Int?
    let name: String?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
