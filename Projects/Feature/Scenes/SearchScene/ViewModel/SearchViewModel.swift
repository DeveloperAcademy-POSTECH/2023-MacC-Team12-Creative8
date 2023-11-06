//
//  SearchViewModel.swift
//  Feature
//
//  Created by 최효원 on 10/7/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import Core
import Combine

final class SearchViewModel: ObservableObject {
  let dataService: SetlistDataService = SetlistDataService.shared
  let koreanConverter: KoreanConverter = KoreanConverter.shared
  
  @Published var searchText: String = ""
  @Published var searchIsPresented: Bool = false
  @Published var artistList: [MusicBrainzArtist] = []
  @Published var isLoading: Bool = false
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    // Combine Publisher for searchText
    let searchTextPublisher = $searchText
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .removeDuplicates()
    
    // Subscribe to searchTextPublisher and call getArtistList()
    searchTextPublisher
      .sink { [weak self] searchText in
        self?.getArtistList()
      }
      .store(in: &cancellables)
  }
  
  func getArtistList() {
    self.isLoading = true
    
    // Fetch artist list and update isLoading and artistList when completed
    Future<[MusicBrainzArtist], Error> { promise in
      self.dataService.searchArtistsFromMusicBrainz(artistName: self.searchText) { result in
        if let result = result {
          promise(.success(result.artists ?? []))
        } else {
          promise(.failure(NSError(domain: "YourDomain", code: 1, userInfo: nil)))
        }
      }
    }
    .receive(on: DispatchQueue.main)
    .sink { completion in
      switch completion {
      case .finished:
        self.isLoading = false
      case .failure(let error):
        print("Failed to fetch musicbrainz data: \(error)")
      }
    } receiveValue: { artists in
      self.artistList = artists
    }
    .store(in: &cancellables)
  }
}

enum ScrollID: String {
  case top
  case searchBar
}
