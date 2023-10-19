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
  let created: String?
  let count: Int?
  let offset: Int?
  let artists: [MusicBrainzArtist]?
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
  let sortName: String?
  let typeID: String?
  let name: String?
  let locale: String?
  let type: String?
  let primary: Bool?
}

// MARK: - Area
public struct Area: Codable {
  let id: String?
  let type: String?
  let typeID: String?
  let name: String?
  let sortName: String?
}
