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
  public var artistInfo: SaveArtistInfo = SaveArtistInfo(name: "", country: "", alias: "", mbid: "", gid: 0, imageUrl: "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png", songList: [])

  init(artistInfo: SaveArtistInfo) {
    self.artistInfo = artistInfo
  }
}
