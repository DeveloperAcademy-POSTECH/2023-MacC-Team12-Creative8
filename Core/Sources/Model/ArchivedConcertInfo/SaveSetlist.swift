//
//  SaveSetlist.swift
//  Core
//
//  Created by A_Mcflurry on 10/22/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation

public struct SaveSetlist: Codable {
  public var setlistId: String
  public var date: Date
  public var venue: String
  public var title: String
  public var city: String
  public var country: String

  public init(setlistId: String, date: Date, venue: String, title: String, city: String, country: String) {
    self.setlistId = setlistId
    self.date = date
    self.venue = venue
    self.title = title
    self.city = city
    self.country = country
  }
}
