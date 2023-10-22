//
//  ArchivedConcertInfo.swift
//  Core
//
//  Created by A_Mcflurry on 10/22/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftData

@Model
public class ArchivedConcertInfo {
  @Relationship public var artistInfo: SaveArtistInfo
  @Relationship public var setlist: SaveSetlist

  init(artistInfo: SaveArtistInfo, setlist: SaveSetlist) {
    self.artistInfo = artistInfo
    self.setlist = setlist
  }
}

@Model
public class SaveSetlist: Identifiable {
  public var id: UUID
  public var setlistId: String
  public var date: String
  public var venue: String
  public var title: String

  init(id: UUID, setlistId: String, date: String, venue: String, title: String) {
    self.id = id
    self.setlistId = setlistId
    self.date = date
    self.venue = venue
    self.title = title
  }
}
