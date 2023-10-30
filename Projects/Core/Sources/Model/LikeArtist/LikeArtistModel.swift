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
  public var artistInfo: SaveArtistInfo

  init(artistInfo: SaveArtistInfo) {
    self.artistInfo = artistInfo
  }
}
