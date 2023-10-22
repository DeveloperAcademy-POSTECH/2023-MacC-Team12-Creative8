//
//  SearchHistoryModel.swift
//  Core
//
//  Created by A_Mcflurry on 10/10/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import SwiftData

@Model
public final class SearchHistory {
  public var artistInfo: [SaveArtistInfo]

  init(artistInfo: [SaveArtistInfo]) {
    self.artistInfo = artistInfo
  }
}
