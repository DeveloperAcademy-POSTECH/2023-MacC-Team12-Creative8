//
//  GeniusSongsModel.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

// MARK: - GeniusSongsModel
public struct GeniusSongsModel: Codable {
  public let response: SongsResponse?
}

// MARK: - Response
public struct SongsResponse: Codable {
  public let songs: [GeniusSong]?
  public let nextPage: Int?
  
  enum CodingKeys: String, CodingKey {
    case songs
    case nextPage = "next_page"
  }
}

// MARK: - Song
public struct GeniusSong: Codable {
  public let headerImageThumbnailURL: String?
  public let headerImageURL: String?
  public let id: Int?
  public let songArtImageThumbnailURL: String?
  public let songArtImageURL: String?
  public let title, titleWithFeatured: String?
  
  enum CodingKeys: String, CodingKey {
    case headerImageThumbnailURL = "header_image_thumbnail_url"
    case headerImageURL = "header_image_url"
    case id
    case songArtImageThumbnailURL = "song_art_image_thumbnail_url"
    case songArtImageURL = "song_art_image_url"
    case title
    case titleWithFeatured = "title_with_featured"
  }
}
