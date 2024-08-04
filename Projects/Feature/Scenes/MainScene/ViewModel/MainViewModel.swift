//
//  MainViewModel.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import Foundation
import SwiftUI
import Core
import Combine
import SwiftData

final class MainViewModel: ObservableObject {
  let dataService = SetlistDataService()
  let koreanConverter = KoreanConverter()
  
  @Published var selectedIndex: Int = 0
  @Published var scrollToIndex: Int = 0
  @Published var isTapped: Bool = false
  @Published var isLoading: Bool = false
  @Published var pageStack: [NavigationDelivery] = []
  @Published var scrollToTop: Bool = false
  @Published var contentHeight: CGFloat = 0.0
  
  @State var dataManager = SwiftDataManager()
  @Published var navigateToArtistView = false
  
  @Environment(\.modelContext) var modelContext
  var setlists = [[Setlist?]?](repeating: nil, count: 100) // MARK: 나중에 꼭 수정하기!
  
  private var cancellables = Set<AnyCancellable>()
  
  func replaceFirstSpaceWithNewline(_ input: String) -> String {
    if input == "Noel Gallagher’s High Flying Birds" {
      return "Noel Gallagher’s\nHigh Flying Birds"
    } else {
      guard let range = input.rangeOfCharacter(from: .whitespaces) else {
        return input
      }
      return input.replacingCharacters(in: range, with: "\n")
    }
  }
  
  func getSetlistsFromSetlistFM(artistMbid: String, idx: Int) {
    self.isLoading = true
    dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: 1) { result in
      if let result = result {
        let filteredSetlists = result.setlist?.filter {
          $0.venue?.name != "SBS Inkigayo"
          && $0.venue?.name != "M Countdown"
          && $0.venue?.name != "Show! Music Core"
          && $0.venue?.name != "KBS Music Bank"
          && $0.venue?.name != "Show Champion"
          && $0.venue?.name != "The Show"
          && $0.venue?.name != "KBS Cool FM"
        } ?? []
        DispatchQueue.main.async {
          self.setlists[idx] = filteredSetlists
          self.isLoading = false
        }
      } else {
        self.isLoading = false
        print("Failed to fetch setlist data.")
      }
    }
  }
  
  func getDateFormatted(dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "dd-MM-yyyy"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy년 MM월 dd일"
    
    if let date = inputFormatter.date(from: dateString) {
      return outputFormatter.string(from: date)
    } else {
      return "-"
    }
  
  func fetchInitialSetlists(likeArtists: [LikeArtist], modelContext: ModelContext) {
    if setlists[0] == nil {
      loadSetlists(likeArtists: likeArtists)
    }
  }
  
  func updateSetlists(likeArtists: [LikeArtist]) {
    loadSetlists(likeArtists: likeArtists)
  }
  
  private func loadSetlists(likeArtists: [LikeArtist]) {
    var idx = likeArtists.count - 1
    for artist in likeArtists.reversed() {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.getSetlistsFromSetlistFM(artistMbid: artist.artistInfo.mbid, idx: idx)
        idx -= 1
      }
    }
  }
  func resetScroll() {
    scrollToIndex = 0
    selectedIndex = 0

  }
  
  func selectArtist(index: Int) {
    selectedIndex = index
    scrollToIndex = index
  }
  
  func scrollToSelectedIndex(proxy: ScrollViewProxy) {
    withAnimation {
      proxy.scrollTo(scrollToIndex, anchor: .center)
    }
  }
  
  func resetScrollToIndex(proxy: ScrollViewProxy, likeArtists: [LikeArtist]) {
    selectedIndex = 0
    scrollToIndex = 0
    scrollToSelectedIndex(proxy: proxy)
  }
  
  func navigationDestination(for value: NavigationDelivery) -> some View {
    if let setlistId = value.setlistId {
      return AnyView(SetlistView(setlistId: setlistId, artistInfo: value.artistInfo.toArtistInfo()))
    } else {
      return AnyView(ArtistView(selectedTab: .constant(.archiving), artistName: value.artistInfo.name, artistAlias: value.artistInfo.alias ?? "", artistMbid: value.artistInfo.mbid))
    }
  }
  
  // MARK: 현지화
  func dayAndMonthDateFormatter(inputDate: String) -> String? {
    guard let languageCode = Locale.current.language.languageCode?.identifier else { return "" }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    // 입력된 날짜 문자열을 "dd-MM-yyyy" 형식으로 변환
    guard let convertedDate = dateFormatter.date(from: inputDate) else {
      return ""
    }
    
    dateFormatter.dateFormat = (languageCode == "ko") ? "MM.dd" : "dd.MM"
    
    // 변환된 날짜를 설정한 형식으로 문자열로 반환
    return dateFormatter.string(from: convertedDate)
  }
  
  func isKorean() -> Bool {
    guard let languageCode = Locale.current.language.languageCode?.identifier else { return false }
    return languageCode == "ko"
  }
}

public enum ButtonType: Int, CaseIterable, Identifiable {
  public var id: Int { self.rawValue }
  case automatic, light, dark
  
  public var icon: String {
    switch self {
    case .automatic:
      return "circle.lefthalf.filled"
    case .light:
      return "sun.max.fill"
    case .dark:
      return "moon.stars.fill"
    }
  }
  
  public var name: String {
    switch self {
    case .light: return "라이트"
    case .dark: return "다크"
    case .automatic: return "자동"
    }
  }
  
  public func getColorScheme() -> ColorScheme? {
    switch self {
    case .automatic: return nil
    case .light: return .light
    case .dark: return .dark
    }
  }
}

extension SaveArtistInfo {
  func toArtistInfo() -> ArtistInfo {
    return ArtistInfo(
      name: self.name,
      alias: self.alias,
      mbid: self.mbid,
      gid: self.gid,
      imageUrl: self.imageUrl,
      songList: self.songList
    )
  }
}
