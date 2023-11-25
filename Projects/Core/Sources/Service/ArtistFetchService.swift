//
//  ArtistFetchService.swift
//  Core
//
//  Created by A_Mcflurry on 11/25/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation

public final class ArtistFetchService: ObservableObject {
  public init() { }

  @Published public var allArtist: [OnboardingModel] = []

  public func fetchData() {
    let serverUrl = "https://seta-yb6k.onrender.com/api/getArtists"
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
}
