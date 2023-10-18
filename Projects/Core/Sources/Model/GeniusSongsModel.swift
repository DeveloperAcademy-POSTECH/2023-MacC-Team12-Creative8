//
//  GeniusSongsModel.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

// MARK: - GeniusSongsModel
struct GeniusSongsModel: Codable {
  let response: SongsResponse?
}

// MARK: - Response
struct SongsResponse: Codable {
  let songs: [GeniusSong]?
  let nextPage: Int?
  
  enum CodingKeys: String, CodingKey {
    case songs
    case nextPage = "next_page"
  }
}

// MARK: - Song
struct GeniusSong: Codable {
  let headerImageThumbnailURL: String?
  let headerImageURL: String?
  let id : Int?
  let songArtImageThumbnailURL: String?
  let songArtImageURL: String?
  let title, titleWithFeatured: String?
  
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
