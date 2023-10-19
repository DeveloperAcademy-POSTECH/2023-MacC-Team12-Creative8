//
//  SetlistListModel.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

// MARK: - SetlistListModel
public struct SetlistListModel: Codable {
  public let type: String?
  public let itemsPerPage: Int?
  public let page: Int?
  public let total: Int?
  public let setlist: [Setlist]?
}

// MARK: - Setlist
public struct Setlist: Codable {
  let id: String?
  let versionId: String?
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
  let mbid: String?
  let name: String?
  let sortName: String?
  let disambiguation: String?
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
  let name: String?
  let info: String?
  let cover: Artist?
  let tape: Bool?
}

// MARK: - Tour
struct Tour: Codable {
  let name: String?
}

// MARK: - Venue
struct Venue: Codable {
  let id: String?
  let name: String?
  let city: City?
  let url: String?
}

// MARK: - City
struct City: Codable {
  let id: String?
  let name: String?
  let state: String?
  let stateCode: String?
  let coords: Coords?
  let country: Country?
}

// MARK: - Coords
struct Coords: Codable {
  let lat: Double?
  let long: Double?
}

// MARK: - Country
struct Country: Codable {
  let code: String?
  let name: String?
}
