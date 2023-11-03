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
  public var filter: String
  
  public init(name: String, mbid: String, filter: String) {
    self.name = name
    self.mbid = mbid
    self.filter = filter
  }
}

public enum OnboardingFilterType: String, CaseIterable {
  case all = "전체"
  case kpop = "케이팝"
  case hiphop = "힙합"
  case band = "밴드"
  case indie = "인디"
  case ballad = "발라드"
  case pop = "해외가수"
}
