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
  public var artistInfo: SaveArtistInfo
  public var setlist: SaveSetlist

  public init(artistInfo: SaveArtistInfo, setlist: SaveSetlist) {
    self.artistInfo = artistInfo
    self.setlist = setlist
  }
}
