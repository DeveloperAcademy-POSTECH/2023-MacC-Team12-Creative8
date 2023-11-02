//
//  OnboardingModel.swift
//  Core
//
//  Created by 최효원 on 11/2/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation

public struct OnboardingModel: Identifiable {
    public var id = UUID()
    public var name: String
    public var mbid: String
    public var filters: [String]
  
  public init(name: String, mbid: String, filters: [String]) {
      self.name = name
      self.mbid = mbid
      self.filters = filters
  }
}
