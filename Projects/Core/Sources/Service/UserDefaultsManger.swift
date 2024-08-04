//
//  UserDefaultsManger.swift
//  Core
//
//  Created by A_Mcflurry on 6/30/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import Foundation

public final class UserDefaultsManger {
  enum UserDefaultsKey: String {
    case accessToken
  }
  
  public var accessToken: String {
    get {
      UserDefaults.standard.string(forKey: UserDefaultsKey.accessToken.rawValue) ?? ""
    } set {
      UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKey.accessToken.rawValue)
    }
  }
}
