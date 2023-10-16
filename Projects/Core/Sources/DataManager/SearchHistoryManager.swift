//
//  SearchHistoryManager.swift
//  Core
//
//  Created by A_Mcflurry on 10/10/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import SwiftData

public final class SearchHistoryManager: ObservableObject {
  public var modelContext: ModelContext?
  
  public func addItem(searchText: String) {
    let newHistory = SearchHistory(searchText: searchText, searchDate: Date())
      modelContext?.insert(newHistory)
      self.save()
  }

  public func deleteItems(item: SearchHistory) {
      modelContext?.delete(item)
      self.save()
  }

  public func deleteAll() {
    do {
      try modelContext?.delete(model: SearchHistory.self)
    } catch {
      print(error.localizedDescription)
    }
    self.save()
  }

  private func save() {
      do {
          try modelContext?.save()
      } catch {
          print(error.localizedDescription)
      }
  }
  public init() {
  }
}
