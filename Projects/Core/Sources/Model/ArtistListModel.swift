//
//  ArtistListModel.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

// MARK: - ArtistListModel
public struct ArtistListModel: Codable {
  public let created: String?
  public let count: Int?
  public let offset: Int?
  public let artists: [MusicBrainzArtist]?
}

// MARK: - Artist
public struct MusicBrainzArtist: Codable {
  public let id: String?
  public let name: String?
  public let sortName: String?
  public let country: String?
  public let area: Area?
  public let beginArea: Area?
  public let aliases: [Alias]?
}

// MARK: - Alias
public struct Alias: Codable {
  public let sortName: String?
  public let typeID: String?
  public let name: String?
  public let locale: String?
  public let type: String?
  public let primary: Bool?
}

// MARK: - Area
public struct Area: Codable {
  public let id: String?
  public let type: String?
  public let typeID: String?
  public let name: String?
  public let sortName: String?
}
