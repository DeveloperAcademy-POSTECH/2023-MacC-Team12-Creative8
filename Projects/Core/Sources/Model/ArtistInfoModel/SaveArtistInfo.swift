//
//  ArtistInfoModel.swift
//  Core
//
//  Created by A_Mcflurry on 10/22/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftData  

@Model
public class SaveArtistInfo: Identifiable {
  public var name: String
  public var alias: String
  public var mbid: String
  public var gid: Int
  public var imageUrl: String
  public var songList: [Titles]
  @Attribute(.unique) public var id: UUID

  init(name: String, alias: String, mbid: String, gid: Int, imageUrl: String, songList: [Titles]) {
    self.name = name
    self.alias = alias
    self.mbid = mbid
    self.gid = gid
    self.imageUrl = imageUrl
    self.songList = songList
    self.id = UUID()
  }
}

@Model
public class Titles: Identifiable {
  public var title: String
  public var subTitle: String
  public var id: UUID

  init(title: String, subTitle: String) {
    self.title = title
    self.subTitle = subTitle
    self.id = UUID()
  }
}
