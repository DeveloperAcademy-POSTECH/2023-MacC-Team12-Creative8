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
  let response: ArtistsResponse?
}

// MARK: - Response
public struct ArtistsResponse: Codable {
  let hits: [Hit]?
}

// MARK: - Hit
public struct Hit: Codable {
  let result: Result?
}

// MARK: - Result
public struct Result: Codable {
  let artistNames: String?
  let headerImageThumbnailURL: String?
  let headerImageURL: String?
  let songArtImageThumbnailURL: String?
  let songArtImageURL: String?
  let primaryArtist: PrimaryArtist?
  
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
  let headerImageURL: String?
  let id: Int?
  let imageURL: String?
  let name: String?
  
  enum CodingKeys: String, CodingKey {
    case headerImageURL = "header_image_url"
    case id
    case imageURL = "image_url"
    case name
  }
}
