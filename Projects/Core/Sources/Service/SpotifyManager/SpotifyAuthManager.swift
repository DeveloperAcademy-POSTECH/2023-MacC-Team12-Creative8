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

public final class SpotifyAuthManager: ObservableObject {
  
  private let authorizationManagerKey = "authorizationManager"
  private let loginCallbackURL = URL(string: "seta://login-callback")!
  private var authorizationState = String.randomURLSafe(length: 128)
  private let keychain = Keychain(service: "com.creative8.seta.Seta")
  
  @Published public var isAuthorized = false
  @Published public var isRetrievingTokens = false
  @Published public var currentUser: SpotifyUser? = nil
  
  public let api = SpotifyAPI(
    authorizationManager: AuthorizationCodeFlowManager(
      clientId: APIKeys.spotifyClientID,
      clientSecret: APIKeys.spotifyClientSecreat
    )
  )
  
  public var cancellables: Set<AnyCancellable> = []
  
  public init() {
    self.api.apiRequestLogger.logLevel = .trace
    
    self.api.authorizationManagerDidChange
      .receive(on: RunLoop.main)
      .sink(receiveValue: authorizationManagerDidChange)
      .store(in: &cancellables)
    
    self.api.authorizationManagerDidDeauthorize
      .receive(on: RunLoop.main)
      .sink(receiveValue: authorizationManagerDidDeauthorize)
      .store(in: &cancellables)
    
    
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
    }
    else {
      print("did NOT find authorization information in keychain")
    }
    
  }
  
  public func authorize() {
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
  
  public func authorizationManagerDidChange() {
    
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
  
  public func authorizationManagerDidDeauthorize() {
    
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
  
  public func retrieveCurrentUser(onlyIfNil: Bool = true) {
    
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
  
}
