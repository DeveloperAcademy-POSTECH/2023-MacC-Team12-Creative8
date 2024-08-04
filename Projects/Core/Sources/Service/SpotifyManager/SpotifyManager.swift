//
//  SpotifyAuthManager.swift
//  Core
//
//  Created by A_Mcflurry on 7/14/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SpotifyWebAPI
import Combine
import UIKit
import KeychainAccess

public final class SpotifyManager: ObservableObject {
  public static let shared = SpotifyManager()
  
  private let authorizationManagerKey = "authorizationManager"
  private let loginCallbackURL = URL(string: "seta-login://callback")!
  private var authorizationState = String.randomURLSafe(length: 128)
  private let keychain = Keychain(service: "com.creative8.seta.Seta")
  
  private var isAuthorized = false
  private var isRetrievingTokens = false
  private var currentUser: SpotifyUser?
  
  private let api = SpotifyAPI(
    authorizationManager: AuthorizationCodeFlowManager(
      clientId: APIKeys.spotifyClientID,
      clientSecret: APIKeys.spotifyClientSecreat
    )
  )
  
  private var cancellables: Set<AnyCancellable> = []
  
  private init() {
    self.api.apiRequestLogger.logLevel = .trace
    
    self.api.authorizationManagerDidChange
      .receive(on: RunLoop.main)
      .sink(receiveValue: authorizationManagerDidChange)
      .store(in: &cancellables)
    
    self.api.authorizationManagerDidDeauthorize
      .receive(on: RunLoop.main)
      .sink(receiveValue: authorizationManagerDidDeauthorize)
      .store(in: &cancellables)
    
    getAuthorizationManager()
    
  }
  
  private func getAuthorizationManager() {
    if let authManagerData = keychain[data: self.authorizationManagerKey] {
      
      do {
        // Try to decode the data.
        let authorizationManager = try JSONDecoder().decode(
          AuthorizationCodeFlowManager.self,
          from: authManagerData
        )
        print("found authorization information in keychain")
        
        self.api.authorizationManager = authorizationManager
        
      } catch {
        print("could not decode authorizationManager from data:\n\(error)")
      }
    } else {
      print("did NOT find authorization information in keychain")
    }
  }
  
  private func authorize() {
    print(self.loginCallbackURL)
    let url = self.api.authorizationManager.makeAuthorizationURL(
      redirectURI: self.loginCallbackURL,
      showDialog: true,
      state: self.authorizationState,
      scopes: [
        .playlistModifyPrivate,
        .playlistModifyPublic
      ]
    )!
    UIApplication.shared.open(url)
    
  }
  
  private func authorizationManagerDidChange() {
    
    self.isAuthorized = self.api.authorizationManager.isAuthorized()
    
    print(
      "Spotify.authorizationManagerDidChange: isAuthorized:",
      self.isAuthorized
    )
    
    self.retrieveCurrentUser()
    
    do {
      let authManagerData = try JSONEncoder().encode(
        self.api.authorizationManager
      )
      
      self.keychain[data: self.authorizationManagerKey] = authManagerData
      print("did save authorization manager to keychain")
      
    } catch {
      print(
        "couldn't encode authorizationManager for storage " +
        "in keychain:\n\(error)"
      )
    }
    
  }
  
  private func authorizationManagerDidDeauthorize() {
    
    self.isAuthorized = false
    
    self.currentUser = nil
    
    do {
      try self.keychain.remove(self.authorizationManagerKey)
      print("did remove authorization manager from keychain")
      
    } catch {
      print(
        "couldn't remove authorization manager " +
        "from keychain: \(error)"
      )
    }
  }
  
  private func retrieveCurrentUser(onlyIfNil: Bool = true) {
    
    if onlyIfNil && self.currentUser != nil {
      return
    }
    
    guard self.isAuthorized else { return }
    
    self.api.currentUserProfile()
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { completion in
          if case .failure(let error) = completion {
            print("couldn't retrieve current user: \(error)")
          }
        },
        receiveValue: { user in
          self.currentUser = user
        }
      )
      .store(in: &cancellables)
  }
  
  public func handleURL(_ url: URL) {
    guard url.scheme == self.loginCallbackURL.scheme else {
      print("not handling URL: unexpected scheme: '\(url)'")
      return
    }
    
    print("received redirect from Spotify: '\(url)'")
    
    self.isRetrievingTokens = true
    
    self.api.authorizationManager.requestAccessAndRefreshTokens(
      redirectURIWithQuery: url,
      state: self.authorizationState
    )
    .receive(on: RunLoop.main)
    .sink(receiveCompletion: { completion in
      self.isRetrievingTokens = false
      
      if case .failure(let error) = completion {
        print("couldn't retrieve access and refresh tokens:\n\(error)")
        if let authError = error as? SpotifyAuthorizationError,
           authError.accessWasDenied {
        }
      }
    })
    .store(in: &cancellables)
    
    self.authorizationState = String.randomURLSafe(length: 128)
    authorizationManagerDidChange()
    
  }
  
  public func addPlayList(name: String, musicList: [(String, String?)], venue: String?, _ completionHandeler: ()->Void) {
    if currentUser == nil {
      authorize()
    } else {
      performPlaylistCreation(name: name, musicList: musicList, venue: venue)
      completionHandeler()
    }
  }

  private func performPlaylistCreation(name: String, musicList: [(String, String?)], venue: String?) {
    var trackUris: [String] = []
    var playlistUri: String = ""
    
    func searchTracks() -> AnyPublisher<Void, Error> {
      
      return Publishers.Sequence(sequence: musicList)
        .flatMap(maxPublishers: .max(1)) { song -> AnyPublisher<String?, Never> in
          let query = "\(song.1 ?? "") \(song.0)"
          print("@LOG query: \(query)")
          let categories: [IDCategory] = [.artist, .track]
          
          return self.api.search(query: query, categories: categories, limit: 1)
            .map { searchResult in
              print("@LOG searchResult \(searchResult.tracks?.items.first?.name ?? "nil")")
              return searchResult.tracks?.items.first?.uri
            }
            .replaceError(with: nil) // Ignore errors and replace with nil
            .eraseToAnyPublisher()
        }
        .compactMap { $0 } // Filter out nil values
        .collect()
        .map { nonDuplicateTrackUris in
          trackUris = nonDuplicateTrackUris
        }
        .eraseToAnyPublisher()
    }
    
    func createPlaylist() -> AnyPublisher<Void, Error> {
      guard let userURI: SpotifyURIConvertible = self.currentUser?.uri else {
        return Fail(error: ErrorType.userNotFound).eraseToAnyPublisher()
      }
      
      let playlistDetails = PlaylistDetails(name: "\(name) @ \(DateFormatter.spotifyAlbumLong.string(from: Date()))",
                                            isPublic: false,
                                            isCollaborative: false,
                                            description: "Seta에서 생성된 플레이리스트 입니다.")
      
      return self.api.createPlaylist(for: userURI, playlistDetails)
        .map { playlist in
          print("Playlist created: \(playlist)")
          playlistUri = playlist.uri
        }
        .eraseToAnyPublisher()
    }
    
    func addTracks() -> AnyPublisher<Void, Error> {
      guard !trackUris.isEmpty else {
        return Fail(error: ErrorType.noTracksFound).eraseToAnyPublisher()
      }
      
      let uris: [SpotifyURIConvertible] = trackUris
      
      return self.api.addToPlaylist(playlistUri, uris: uris)
        .map { result in
          print("Items added successfully. Result: \(result)")
        }
        .eraseToAnyPublisher()
    }
    
    // Chain the functions sequentially
    searchTracks()
      .flatMap { _ in createPlaylist() }
      .flatMap { _ in addTracks() }
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("Playlist creation completed successfully.")
        case .failure(let error):
          print("Error: \(error)")
        }
      }, receiveValue: {})
      .store(in: &cancellables)
  }
  
  private enum ErrorType: Error {
    case trackNotFound
    case userNotFound
    case noTracksFound
  }
}
