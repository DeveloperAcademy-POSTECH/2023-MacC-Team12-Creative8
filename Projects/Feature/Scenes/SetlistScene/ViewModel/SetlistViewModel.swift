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
  @Published var showModal: Bool
  @Published var isLoading: Bool
  
  let koreanConverter = KoreanConverter.shared
  let dataService = SetlistDataService.shared
  let artistDataManager = ArtistDataManager.shared
  let dataManager = SwiftDataManager()
  
  var setlistSongName: [String] = []
  var setlistSongKoreanName: [String] = []
  
  init() {
    self.isBookmarked = false
    self.showModal = false
    self.isLoading = false
  }
  
  func isEmptySetlist(_ setlist: Setlist) -> Bool {
    if setlist.sets?.setsSet?.isEmpty == true {
      return true
    }
    return false
  }
  
  func getFormattedDateFromString(date: String, format: String) -> String? {
    let inputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd-MM-yyyy"
      return formatter
    }()
    
    let outputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = format
      return formatter
    }()
    
    if let inputDate = inputDateFormatter.date(from: date) {
      return outputDateFormatter.string(from: inputDate)
    } else {
      return nil
    }
  }
  
  func convertDateStringToDate(_ dateString: String, format: String = "dd-MM-yyyy") -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Optional: Specify the locale
    
    if let date = dateFormatter.date(from: dateString) {
      return date
    } else {
      return nil // 날짜 형식이 맞지 않을 경우 nil 반환
    }
  }

}
