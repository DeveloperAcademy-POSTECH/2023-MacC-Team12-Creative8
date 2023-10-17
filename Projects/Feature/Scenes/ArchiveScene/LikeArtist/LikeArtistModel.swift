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
public class LikeArtist {
  public var artistName: String
  public var artistApiName: String
  public var artistImage: URL
  public var id: UUID

  init(artistName: String, artistApiName: String, artistImage: URL) {
    self.artistName = artistName
    self.artistApiName = artistApiName
    self.artistImage = artistImage
    self.id = UUID()
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
