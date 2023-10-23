//
//  ArtistInfoModel.swift
//  Core
//
//  Created by 고혜지 on 10/18/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

public struct ArtistInfo {
  public var name: String
  public var alias: String?
  public var mbid: String
  public var gid: Int?
  public var imageUrl: String?
  public var songList: [(String, String?)]?

  public init(name: String, alias: String? = nil, mbid: String, gid: Int? = nil, imageUrl: String? = nil, songList: [(String, String?)]? = nil) {
    self.name = name
    self.alias = alias
    self.mbid = mbid
    self.gid = gid
    self.imageUrl = imageUrl
    self.songList = songList
  }
}
