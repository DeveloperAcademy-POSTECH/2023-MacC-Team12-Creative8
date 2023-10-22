//
//  LikeArtistManager.swift
//  Feature
//
//  Created by A_Mcflurry on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.

import SwiftUI
import SwiftData

public final class SwiftDataManager: ObservableObject {
  public var modelContext: ModelContext?

  public init(modelContext: ModelContext? = nil) { self.modelContext = modelContext }

  // MARK: - Save SwiftData func
  public func save() {
    do {
      try modelContext?.save()
    } catch {
      print(error.localizedDescription)
    }
  }

  // MARK: - songList Encoder, Decoder
  private func songListEncoder(_ songList: [(String, String?)]) -> [Titles] {
    var titlesList: [Titles] = []

    for (title, subTitle) in songList {
      let subTitleValue = subTitle ?? ""
      let titleObject = Titles(title: title, subTitle: subTitleValue)
      titlesList.append(titleObject)
    }

    return titlesList
  }

  public func songListDecoder(_ songList: [Titles]) -> [(String, String?)] {
    var decodedList: [(String, String?)] = []

    for title in songList {
      let titleValue = title.title
      let subTitleValue = title.subTitle
      let decodedTuple: (String, String?) = (titleValue, subTitleValue)
      decodedList.append(decodedTuple)
    }

    return decodedList
  }

  //MARK: - LikeArtist
  public func addLikeArtist(name: String,
                            country: String,
                            alias: String,
                            mbid: String,
                            gid: Int,
                            imageUrl: String?,
                            songList: [(String, String?)]) {

    let newLikeArtist = LikeArtist(artistInfo: SaveArtistInfo(name: name, 
                                                              country: country,
                                                              alias: alias,
                                                              mbid: mbid,
                                                              gid: gid,
                                                              imageUrl: imageUrl ?? "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png",
                                                              songList: self.songListEncoder(songList)))
    modelContext?.insert(newLikeArtist)
    self.save()
  }

  public func deleteLikeArtist(_ item: LikeArtist) {
    modelContext?.delete(item)
    self.save()
  }

  //MARK: - SearchHistory
  public func addSearchHistory(name: String,
                               country: String,
                               alias: String,
                               mbid: String,
                               gid: Int,
                               imageUrl: String?,
                               songList: [(String, String?)]) {

    let newSearchHistory = SearchHistory(artistInfo: SaveArtistInfo(name: name,
                                                                    country: country,
                                                                    alias: alias,
                                                                    mbid: mbid,
                                                                    gid: gid,
                                                                    imageUrl: imageUrl ?? "https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png",
                                                                    songList: self.songListEncoder(songList)))
    modelContext?.insert(newSearchHistory)
    self.save()
  }

  public func deleteSearchHistory(_ item: SearchHistory) {
    modelContext?.delete(item)
    self.save()
  }

  public func deleteSearchHistoryAll() {
    do {
      try modelContext?.delete(model: SearchHistory.self)
    } catch {
      print(error.localizedDescription)
    }
    self.save()
  }

  // MARK: - ArchivedConcertInfo
  public func addArchivedConcertInfo(_ artistInfo: SaveArtistInfo, _ setlist: SaveSetlist) {
    let newConcert = ArchivedConcertInfo(artistInfo: artistInfo, setlist: setlist)
    modelContext?.insert(newConcert)
  }

  public func deleteArchivedConcertInfo(_ item: ArchivedConcertInfo) {
    modelContext?.delete(item)
  }
}
