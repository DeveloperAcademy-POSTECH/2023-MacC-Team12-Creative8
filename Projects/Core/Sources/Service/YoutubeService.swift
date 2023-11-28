//
//  YoutubeService.swift
//  Core
//
//  Created by 최효원 on 11/29/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftUI
import GoogleSignIn
import GoogleAPIClientForREST

public final class YoutubeService {
  private let service = GTLRYouTubeService()
  
  var musicListsTitle: [String] = ["악뮤 Love Lee", "아이브 Either Way", "SZA Snooze", "Doja Cat Paint The Town Red", "Dua Lipa New Rules", "The Kid Stay", "Justin Stay", "JK 3D", "Kanye HomeComing", "Post Candy", "Post Malone Circle", "아이유 좋은날", "아이유 Good day", "비틀즈 렛잇비", "The Beatles Let it", "Doja Agora Hills", "The Weeknd Save yout tears", "정국 세븐", "비비 불륜", "해리 애즈잇워즈", "르세라핌 피어리스", "아이유 bbibbi", "lil nas X industry baby"]
  
  func createYouTubeService(user: GIDGoogleUser) -> GTLRYouTubeService {
    let service = GTLRYouTubeService()
    service.authorizer = user.fetcherAuthorizer
    
    return service
  }
  
  func checkState() {
    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
      if error != nil || user == nil {
        print("Not Sign in")
      } else {
        //로그인 된 상태
      }
    }
  }
  
  func googleSignIn(completionHandler: @escaping (Bool) -> Void) {
    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
      if error == nil {
        print("Managed to restore previous sign in!\nScopes: \(String(describing: user?.grantedScopes))")
        
        requestScopes(googleUser: user!) { success in
          if success == true {
            completionHandler(true)
          } else {
            completionHandler(false)
          }
        }
      } else {
        print("No previous user!\nThis is the error: \(String(describing: error?.localizedDescription))")
        let signInConfig = GIDConfiguration.init(clientID: APIKeys().googleClientID)
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, signInError in
          if signInError == nil {
            if let gUser = signInResult?.user {
              requestScopes(googleUser: gUser) { signInSuccess in
                if signInSuccess == true {
                  completionHandler(true)
                } else {
                  completionHandler(false)
                }
              }
            } else {
              print("error with signing in: \(String(describing: signInError)) ")
              self.service.authorizer = nil
              completionHandler(false)
            }
          }
        }
      }
    }
    
    
    func requestScopes(googleUser: GIDGoogleUser, completionHandler: @escaping (Bool) -> Void) {
      
      let grantedScopes = googleUser.grantedScopes
      if grantedScopes == nil || !grantedScopes!.contains(APIKeys().grantedScopes) {
        let additionalScopes = APIKeys().additionalScopes
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
        
        googleUser.addScopes(additionalScopes, presenting: presentingViewController) { result, scopeError in
          if scopeError == nil {
            
            googleUser.refreshTokensIfNeeded { user, error in
              guard error == nil else { print("refreshError :  \(String(describing: error?.localizedDescription))")
                return }
              
              let authorizer = user?.fetcherAuthorizer
              self.service.authorizer = authorizer
              completionHandler(true)
            }
            
          } else {
            completionHandler(false)
            print("Error with adding scopes: \(String(describing: scopeError?.localizedDescription))")
          }
        }
      } else {
        print("Already contains the scopes!")
        completionHandler(true)
      }
    }
  }
  
  func createPlaylist(service: GTLRYouTubeService, title: String) {
    let playlist = GTLRYouTube_Playlist()
    let snippet = GTLRYouTube_PlaylistSnippet()
    snippet.title = title
    playlist.snippet = snippet
    
    let query = GTLRYouTubeQuery_PlaylistsInsert.query(withObject: playlist, part: "snippet")
    service.executeQuery(query) { (_, result, error) in
      if let error = error {
        print("Error creating playlist: \(error.localizedDescription)")
      } else if let playlist = result as? GTLRYouTube_Playlist {
        let playlistId = playlist.identifier
        self.searchAndInsertForMusicTitles(service: service, playlistId: playlistId!)
        print("Playlist created with ID: \(playlistId ?? "Unknown")")
      }
    }
  }
  
  
  func getSearchList(service: GTLRYouTubeService, playlistId: String, title: String) {
    let query = GTLRYouTubeQuery_SearchList.query(withPart: "snippet")
    query.maxResults = 1
    query.type = "video"
    query.q = title
    service.executeQuery(query) { ticket, searchList, ytError in
      
      if ytError == nil {
        let searchList = searchList as? GTLRYouTube_SearchListResponse
        if (searchList?.items) != nil {
          self.insertPlaylistItem(service: service, playlistId: playlistId, videoId: searchList?.items![0].identifier?.videoId ?? "")
        } else {
          print("Search list empty")
        }
      } else {
        print("Youtube error: \(String(describing: ytError?.localizedDescription))")
      }
    }
  }
  
  func insertPlaylistItem(service: GTLRYouTubeService, playlistId: String, videoId: String, maxRetries: Int = 10) {
    var retryCount = 0
    var backoffTime = 1
    
    func insert() {
      let playlistItem = GTLRYouTube_PlaylistItem()
      playlistItem.snippet = GTLRYouTube_PlaylistItemSnippet()
      playlistItem.snippet!.playlistId = playlistId
      
      let resourceId = GTLRYouTube_ResourceId()
      resourceId.kind = "youtube#video"
      resourceId.videoId = videoId
      
      playlistItem.snippet!.resourceId = resourceId
      
      let query = GTLRYouTubeQuery_PlaylistItemsInsert.query(withObject: playlistItem, part: "snippet")
      
      service.executeQuery(query) { (_, _, error) in
        if let error = error {
          print("Error adding video \(videoId) to playlist \(playlistId): \(error.localizedDescription)")
          // Retry if needed
          retry()
        } else {
          print("Added video \(videoId) to playlist \(playlistId)")
        }
      }
    }
    
    func retry() {
      retryCount += 1
      if retryCount <= maxRetries {
        print("Attempt \(retryCount) failed. Retrying in \(backoffTime) seconds...")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(backoffTime)) {
          backoffTime += 1  // Exponential backoff
          insert()
        }
      } else {
        print("Max retry count reached. Unable to insert video \(videoId) to playlist \(playlistId)")
      }
    }
    
    // Try inserting initially
    insert()
  }
  
  
  func searchAndInsertForMusicTitles(service: GTLRYouTubeService, playlistId: String) {
    
    for title in musicListsTitle {
      getSearchList(service: service, playlistId: playlistId, title: title)
    }
  }
}
