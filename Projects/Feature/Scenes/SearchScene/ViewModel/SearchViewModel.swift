//
//  SearchViewModel.swift
//  Feature
//
//  Created by 최효원 on 10/7/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import Core

final class SearchViewModel: ObservableObject {
  let dataService: SetlistDataService = SetlistDataService.shared
  let koreanConverter: KoreanConverter = KoreanConverter.shared
  
  @Published var searchText: String = ""
  @Published  var searchIsPresented: Bool = false
  @Published var artistList: [MusicBrainzArtist] = []
  @Published var isLoading: Bool = false
  
  func getArtistList() {
    self.isLoading = true
    self.dataService.searchArtistsFromMusicBrainz(artistName: self.searchText) { result in
          if let result = result {
              DispatchQueue.main.async {
                self.artistList = result.artists ?? []
                self.isLoading = false
              }
          } else {
              print("Failed to fetch musicbrainz data.")
          }
      }
  }
  
}
enum ScrollID: String {
  case top
  case searchBar
}
