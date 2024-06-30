//
//  SpotifyManager.swift
//  Core
//
//  Created by A_Mcflurry on 6/30/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import Foundation

public final class SpotifyManager {
  public init(
  ) {
    self.userDefaultsManager = UserDefaultsManger()
  }
  private let userDefaultsManager: UserDefaultsManger
  
  public func addPlayList(name: String, musicList: [(String, String?)], venue: String?) {
    
  }
  
  public func getAccessToken() {
    
  }
}
