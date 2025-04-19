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

    // 주 요청 URL을 새로 받은 URL로 변경
    private let urls: [URL] = [
        URL(string: "https://port-0-seta-server-bkcl2bloxy1ug8.sel5.cloudtype.app/api/getArtists")!,
        URL(string: "https://seta-server.fly.dev/api/getArtists")!
    ]

    public func fetchData(completion: @escaping (Bool) -> Void) {
        fetch(at: 0, completion: completion)
    }

    private func fetch(at index: Int, completion: @escaping (Bool) -> Void) {
        guard index < urls.count else {
            completion(false)
            return
        }
        let url = urls[index]
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Request to \(url) failed: \(error?.localizedDescription ?? "Unknown error")")
                self.fetch(at: index + 1, completion: completion)
                return
            }
            do {
                let decoder = JSONDecoder()
                let artists = try decoder.decode([OnboardingModel].self, from: data)
                DispatchQueue.main.async {
                    self.allArtist = artists
                    completion(true)
                }
            } catch {
                print("Decoding error on \(url): \(error.localizedDescription)")
                self.fetch(at: index + 1, completion: completion)
            }
        }.resume()
    }
}
