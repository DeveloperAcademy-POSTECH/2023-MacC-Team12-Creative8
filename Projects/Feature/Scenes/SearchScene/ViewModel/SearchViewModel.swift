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
  let artistFetchService = ArtistFetchService()

  @Published var searchText: String = ""
  @Published var searchIsPresented: Bool = false
  @Published var artistList: [MusicBrainzArtist] = []
  @Published var isLoading: Bool = false
  @Published var domesticArtists: [OnboardingModel] = []
  @Published var foreignArtists: [OnboardingModel] = []
  private var cancellables = Set<AnyCancellable>()

  init() {
    let searchTextPublisher = $searchText
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .removeDuplicates()
    searchTextPublisher
      .sink { [weak self] _ in
        self?.getSearchArtistList()
      }
      .store(in: &cancellables)

    if artistFetchService.allArtist.isEmpty {
      artistFetchService.fetchData { [weak self] success in
		  guard let self else { return }
          if success {
			  getRandomArtistInfos()
		  }
      }
    }
  }
	
	func getRandomArtistInfos() {
		if searchIsPresented { return }
		
		var domestic: [OnboardingModel] = []
		var foreign: [OnboardingModel] = []
		
		for data in artistFetchService.allArtist {
			guard data.url != nil && data.url != "" && data.url != "https://assets.genius.com/images/default_avatar_300.png?1722887932" else { continue }
			guard let tags = data.tags else { continue }
			
			if tags.contains("K-Pop") && data.country == "South Korea" {
				domestic.append(data)
			} else if data.country != "South Korea" && !data.country.isEmpty {
				foreign.append(data)
			}
		}
		print(domestic, foreign)
		domesticArtists = Array(domestic.shuffled().prefix(9))
		foreignArtists = Array(foreign.shuffled().prefix(9))
	}

  func getSearchArtistList() {
    self.isLoading = true
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
