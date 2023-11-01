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
//  @Published var isEmptySetlist: Bool
  @Published var showModal: Bool
  
  let koreanConverter = KoreanConverter.shared
  let dataService = SetlistDataService.shared
  let dataManager = SwiftDataManager()
  
  //  func isBookmark(_ concertInfo: [ArchivedConcertInfo], _ setlist: Setlist?) {
  //    self.isBookmarked = {
  //      for i in 0..<concertInfo.count {
  //        if concertInfo[i].setlist.setlistId == setlist?.id { return true }
  //      }
  //      return false
  //    }()
  //  }
  
  var setlistSongName: [String] = []
  var setlistSongKoreanName: [String] = []
  var setlistArtistName: [String] = []
  
  init() {
    self.isBookmarked = false
//    self.isEmptySetlist = false
    self.showModal = false
  }
  
  func isEmptySetlist(_ setlist: Setlist) -> Bool {
    if setlist.sets?.setsSet?.isEmpty == true {
      return true
    }
    return false
  }
}
