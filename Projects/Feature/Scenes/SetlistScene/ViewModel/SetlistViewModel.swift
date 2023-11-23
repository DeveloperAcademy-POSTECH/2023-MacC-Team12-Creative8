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
  
  let koreanConverter = KoreanConverter()
  let dataService = SetlistDataService()
  let artistDataManager = ArtistDataManager()
  let dataManager = SwiftDataManager()
  
  // [(songTitle, artistName)]
  var setlistSongName: [(String, String?)] = []
  var setlistSongKoreanName: [(String, String?)] = []
  
  init() {
    self.isBookmarked = false
    self.showModal = false
    self.isLoading = false
  }
  
  func isEmptySetlist(_ setlist: Setlist) -> Bool {
    return setlist.sets?.setsSet?.isEmpty == true
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

  func createArrayForExportPlaylist(setlist: Setlist?, songList: [Titles], artistName: String?) {
    
    setlistSongName = []
    setlistSongKoreanName = []
    
    for session in setlist?.sets?.setsSet ?? [] {
      for song in session.song ?? [] {
        if let title = song.name {
          var name: String?
          if let cover = song.cover?.name { // 커버곡이면
            name = cover
          } else { // 커버곡이 아니면
            name = artistName
          }
          
          // 영문 배열에 추가
          if !self.setlistSongName.contains(where: { $0 == (title, name) }) {
            self.setlistSongName.append((title, name))
          }
          
          // 한글 배열에 추가
          let tmp = self.koreanConverter.findKoreanTitle(title: title, songList: songList) ?? title
          if !self.setlistSongKoreanName.contains(where: { $0 == (tmp, name) }) {
            self.setlistSongKoreanName.append((tmp, name))
          }
          
        }
        
      }
    }
    
  }
}
