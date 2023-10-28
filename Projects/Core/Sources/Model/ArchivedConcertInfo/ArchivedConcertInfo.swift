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
  public var artistInfo: SaveArtistInfo = SaveArtistInfo(name: "", country: "", alias: "", mbid: "", gid: 0, imageUrl: "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png", songList: [])
  public var setlist: SaveSetlist = SaveSetlist(setlistId: "", date: Date(), venue: "", title: "")

  public init(artistInfo: SaveArtistInfo, setlist: SaveSetlist) {
    self.artistInfo = artistInfo
    self.setlist = setlist
  }
}
