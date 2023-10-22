//
//  SaveSetlist.swift
//  Core
//
//  Created by A_Mcflurry on 10/22/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation

public struct SaveSetlist: Codable, Hashable {
  public var setlistId: String
  public var date: String
  public var venue: String
  public var title: String

  init(setlistId: String, date: String, venue: String, title: String) {
    self.setlistId = setlistId
    self.date = date
    self.venue = venue
    self.title = title
  }
}
