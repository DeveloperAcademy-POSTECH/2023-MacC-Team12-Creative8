//
//  SetlistViewModel.swift
//  Feature
//
//  Created by 고혜지 on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import Core

final class SetlistViewModel: ObservableObject {
  @Published var isBookmarked: Bool
  @Published var isEmptySetlist: Bool

  func isBookmark(_ concertInfo: [ArchivedConcertInfo], _ setlist: Setlist?) {
    self.isBookmarked = {
      for index in 0..<concertInfo.count {
        if concertInfo[index].setlist.setlistId == setlist?.id { return true }
      }
      return false
    }()
  }

  var setlistSongName: [String] = []
  var setlistSongKoreanName: [String] = []
  var setlistArtistName: [String] = []
  
  init() {
    self.isBookmarked = false
    self.isEmptySetlist = false
  }
}
