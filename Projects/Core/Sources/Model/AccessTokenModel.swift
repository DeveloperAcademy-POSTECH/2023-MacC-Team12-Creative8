//
//  AccessTokenModel.swift
//  Core
//
//  Created by A_Mcflurry on 6/30/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import Foundation

public struct AccessTokenModel: Decodable {
  private let accessToken: String
  private let tokenType: String
  
  public var token: String {
    return "\(tokenType) \(accessToken)"
  }

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case tokenType = "token_type"
  }
}
