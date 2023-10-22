//
//  ArtistInfoModel.swift
//  Core
//
//  Created by A_Mcflurry on 10/22/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftData

public struct SaveArtistInfo: Codable {
  public var name: String
  public var country: String
  public var alias: String
  public var mbid: String
  public var gid: Int
  public var imageUrl: String
  public var songList: [Titles]

  init(name: String, country: String, alias: String, mbid: String, gid: Int, imageUrl: String, songList: [Titles]) {
    self.name = name
    self.country = country
    self.alias = alias
    self.mbid = mbid
    self.gid = gid
    self.imageUrl = imageUrl
    self.songList = songList
  }
}

public struct Titles: Codable {
  public var title: String
  public var subTitle: String

  init(title: String, subTitle: String) {
    self.title = title
    self.subTitle = subTitle
  }
}
