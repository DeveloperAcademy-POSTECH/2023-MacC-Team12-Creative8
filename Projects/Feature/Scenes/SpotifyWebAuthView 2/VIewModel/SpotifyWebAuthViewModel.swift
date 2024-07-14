//
//  SpotifyWebAuthViewModel.swift
//  Feature
//
//  Created by A_Mcflurry on 7/14/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import Foundation
import CommonCrypto
import Core

final class SpotifyWebAuthViewModel: ObservableObject {
  
  var authorizationRequest: URLRequest {
    let codeChallenge = generateCodeChallenge(codeVerifier: generateCodeVerifier())
    var components = URLComponents(string: "https://accounts.spotify.com/authorize")!
    components.queryItems = [
      URLQueryItem(name: "client_id", value: SpotifyKeys.clientID.rawValue),
      URLQueryItem(name: "response_type", value: "code"),
      URLQueryItem(name: "redirect_uri", value: "seta://login-callback"),
      URLQueryItem(name: "scope", value: "playlist-modify-private playlist-modify-public user-read-private user-read-email"),
      URLQueryItem(name: "code_challenge_method", value: "S256"),
      URLQueryItem(name: "code_challenge", value: codeChallenge)
    ]
    return URLRequest(url: components.url!)
  }
  
  func generateCodeVerifier() -> String {
      let length = 128
      let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
      var codeVerifier = ""
      
      for _ in 0..<length {
          codeVerifier.append(characters.randomElement()!)
      }
      
      return codeVerifier
  }

  func generateCodeChallenge(codeVerifier: String) -> String {
      guard let data = codeVerifier.data(using: .utf8) else { return "" }
      var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
      data.withUnsafeBytes {
          _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &buffer)
      }
      let hash = Data(buffer)
      return hash.base64EncodedString(options: .endLineWithLineFeed)
          .replacingOccurrences(of: "+", with: "-")
          .replacingOccurrences(of: "/", with: "_")
          .replacingOccurrences(of: "=", with: "")
  }

}
