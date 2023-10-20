//
//  LikeArtistModel.swift
//  Feature
//
//  Created by A_Mcflurry on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import SwiftData

@Model
public final class LikeArtist {
  var name: String
  var alias: String
  var mbid: String
  var gid: Int
  var imageUrl: String
  var songList: [Titles]

  init(name: String, alias: String, mbid: String, gid: Int, imageUrl: String, songList: [Titles]) {
    self.name = name
    self.alias = alias
    self.mbid = mbid
    self.gid = gid
    self.imageUrl = imageUrl
    self.songList = songList
  }
}

@Model
public class Titles {
  var title: String
  var subTitle: String

  init(title: String, subTitle: String) {
    self.title = title
    self.subTitle = subTitle
  }
}


// 임시 모델. 합치고 삭제 예정
@Model
public class ArchivedConcertInfo: Identifiable {
  public var concertTitle: String
  public var concertDate: Date
  public var singer: String
  public var setList: [String]
  public var id = UUID()
  
  init(concertTitle: String, concertDate: Date, singer: String, setList: [String]) {
    self.concertTitle = concertTitle
    self.concertDate = concertDate
    self.singer = singer
    self.setList = setList
    self.id = UUID()
  }
}
