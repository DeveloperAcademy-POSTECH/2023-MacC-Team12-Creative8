//
//  LikeArtistManager.swift
//  Feature
//
//  Created by A_Mcflurry on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.

import SwiftUI
import SwiftData

class ListArtistManager: ObservableObject {
  var modelContext: ModelContext?
  
  func addLikeArtist(artistName: String, artistApiName: String, artistImage: URL) {
    let newLikeArtist = LikeArtist(artistName: artistName, artistApiName: artistApiName, artistImage: artistImage)
    modelContext?.insert(newLikeArtist)
    self.save()
  }
  
  func deleteItems(item: LikeArtist) {
    modelContext?.delete(item)
    self.save()
  }
  
  func save() {
    do {
      try modelContext?.save()
    } catch {
      print(error.localizedDescription)
    }
  }
}
