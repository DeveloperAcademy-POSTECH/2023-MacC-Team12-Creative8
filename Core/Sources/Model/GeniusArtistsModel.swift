//
//  GeniusArtistsModel.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

// MARK: - GeniusArtistsModel
public struct GeniusArtistsModel: Codable {
  public let response: ArtistsResponse?
}

// MARK: - Response
public struct ArtistsResponse: Codable {
  public let hits: [Hit]?
}

// MARK: - Hit
public struct Hit: Codable {
  public let result: Result?
}

// MARK: - Result
public struct Result: Codable {
  public let artistNames: String?
  public let headerImageThumbnailURL: String?
  public let headerImageURL: String?
  public let songArtImageThumbnailURL: String?
  public let songArtImageURL: String?
  public let primaryArtist: PrimaryArtist?
  
  enum CodingKeys: String, CodingKey {
    case artistNames = "artist_names"
    case headerImageThumbnailURL = "header_image_thumbnail_url"
    case headerImageURL = "header_image_url"
    case songArtImageThumbnailURL = "song_art_image_thumbnail_url"
    case songArtImageURL = "song_art_image_url"
    case primaryArtist = "primary_artist"
  }
}

// MARK: - PrimaryArtist
public struct PrimaryArtist: Codable {
  public let headerImageURL: String?
  public let id: Int?
  public let imageURL: String?
  public let name: String?
  
  enum CodingKeys: String, CodingKey {
    case headerImageURL = "header_image_url"
    case id
    case imageURL = "image_url"
    case name
  }
}
