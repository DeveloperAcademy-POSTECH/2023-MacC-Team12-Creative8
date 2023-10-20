//
//  LikeArtistManager.swift
//  Feature
//
//  Created by A_Mcflurry on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.

import SwiftUI
import SwiftData

public final class LikeArtistManager: ObservableObject {
  public var modelContext: ModelContext?
  
  public func addLikeArtist(name: String,
                            alias: String?,
                            mbid: String,
                            gid: Int?,
                            imageUrl: String?,
                            songList: [(String, String?)]?) {
    //        let newLikeArtist = LikeArtist(artistInfo: ArtistInfo(name: name,
    //                                                              alias: alias,
    //                                                              mbid: mbid,
    //                                                              gid: gid,
    //                                                              imageUrl: imageUrl,
    //                                                              songList: songList))
    //        modelContext?.insert(newLikeArtist)
    self.save()
  }
  
  public func deleteItems(item: LikeArtist) {
    modelContext?.delete(item)
    self.save()
  }
  
  public func save() {
    do {
      try modelContext?.save()
    } catch {
      print(error.localizedDescription)
    }
  }
}
