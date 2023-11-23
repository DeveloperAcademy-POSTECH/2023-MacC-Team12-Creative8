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
  let dataService = SetlistDataService()
  let artistDataManager = ArtistDataManager()
  let koreanConverter = KoreanConverter()

  @Published var searchText: String = ""
  @Published var searchIsPresented: Bool = false
  @Published var artistList: [MusicBrainzArtist] = []
  @Published var isLoading: Bool = false
  @Published var allArtist: [OnboardingModel] = []

  private var cancellables = Set<AnyCancellable>()

  init() {
    fetchData()
    let searchTextPublisher = $searchText
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .removeDuplicates()
  }

  func fetchData() {
    let serverUrl = "https://port-0-seta-server-bkcl2bloxy1ug8.sel5.cloudtype.app/api/getArtists"
    guard let url = URL(string: serverUrl) else { return }

    URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data, error == nil else {
        print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
        return
      }

      do {
        let decoder = JSONDecoder()
        let artists = try decoder.decode([OnboardingModel].self, from: data)

        DispatchQueue.main.async {
          self.allArtist = artists
        }
      } catch {
        print("Error decoding data: \(error.localizedDescription)")
        print("Decoding error details: \(error)")
      }
    }.resume()
  }

  func getRandomKpopArtists() -> [OnboardingModel] {
      let kpopArtists = allArtist.filter { artist in
          if let tags = artist.tags, artist.country == "South Korea" {
              return tags.contains("K-Pop")
          }
          return false
      }

      return Array(kpopArtists.shuffled().prefix(9))
  }

  func getRandomPopArtists() -> [OnboardingModel] {
    let kpopArtists = allArtist.filter { artist in
      if let tags = artist.tags {
        return tags.contains("Pop")
      }
      return false
    }

    return Array(kpopArtists.shuffled().prefix(9))
  }
}

enum ScrollID: String {
  case top
  case searchBar
}
