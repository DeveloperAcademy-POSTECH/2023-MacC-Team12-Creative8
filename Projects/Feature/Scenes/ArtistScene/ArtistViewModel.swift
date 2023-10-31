//
//  ArtistViewModel.swift
//  Feature
//
//  Created by 고혜지 on 10/21/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import Core
import SwiftUI

class ArtistViewModel: ObservableObject {
  let dataService: SetlistDataService = SetlistDataService.shared
  let koreanConverter: KoreanConverter = KoreanConverter.shared
  let artistDataManager: ArtistDataManager = ArtistDataManager.shared
  let dataManager = SwiftDataManager()
  
  var artistInfo: ArtistInfo?
  var setlists: [Setlist]?
  var page: Int = 1
  var totalPage: Int = 0
  
  @Published var showBookmarkedSetlists: Bool
  @Published var isLoading1: Bool
  @Published var isLoading2: Bool
  @Published var isLoading3: Bool
  @Published var image: UIImage?
  @Published var isLikedArtist: Bool

  init() {
    self.showBookmarkedSetlists = false
    self.isLoading1 = false
    self.isLoading2 = false
    self.isLoading3 = false
    self.image = nil
    self.isLikedArtist = false
  }
  
  func getArtistInfoFromGenius(artistName: String, artistAlias: String?, artistMbid: String) {
    if self.artistInfo == nil {
      self.isLoading1 = true
      artistDataManager.getArtistInfo(artistName: artistName, artistAlias: artistAlias ?? "", artistMbid: artistMbid) { result in
        if let result = result {
          DispatchQueue.main.async {
            self.artistInfo = result
            self.isLoading1 = false
          }
        } else {
          self.artistDataManager.getArtistInfo(artistName: artistAlias ?? "", artistAlias: artistName, artistMbid: artistMbid) { result in
            if let result = result {
              DispatchQueue.main.async {
                self.artistInfo = result
                self.isLoading1 = false
              }
            } else {
              self.isLoading1 = false
              print("Failed to fetch artist info.")
            }
          }
        }
      }
    }
  }
  
  func getSetlistsFromSetlistFM(artistMbid: String) {
    if self.setlists == nil {
      self.isLoading2 = true
      dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: page) { result in
        if let result = result {
          DispatchQueue.main.async {
            self.setlists = result.setlist
            self.totalPage = Int((result.total ?? 1) / (result.itemsPerPage ?? 1) + 1)
            self.isLoading2 = false
          }
        } else {
          self.isLoading2 = false
          print("Failed to fetch setlist data.")
        }
      }
    }
  }

  func fetchNextPage(artistMbid: String) {
    page += 1
    self.isLoading3 = true
    dataService.fetchSetlistsFromSetlistFM(artistMbid: artistMbid, page: page) { result in
      if let result = result {
        DispatchQueue.main.async {
          self.setlists?.append(contentsOf: result.setlist ?? [])
          self.isLoading3 = false
        }
      } else {
        self.isLoading3 = false
        print("Failed to fetch setlist data.")
      }
    }
  }
  
  func loadImage() {
    if let imageUrl = artistInfo?.imageUrl {
      if let url = URL(string: imageUrl) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
          if let data = data, let image = UIImage(data: data) {
            DispatchQueue.main.async {
              self.image = image
            }
          }
        }
        .resume()
      } else {
        //MARK: 아티스트를 찾지 못했을 때 사용할 디폴트 이미지 필요!
        self.image = UIImage(systemName: "person.crop.circle")
        print("Invalid Image URL")
      }
    } else {
      return
    }
  }

  func getFormattedDateFromString(date: String, format: String) -> String? {
    let inputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd-MM-yyyy"
      return formatter
    }()
    
    let outputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = format
      return formatter
    }()
    
    if let inputDate = inputDateFormatter.date(from: date) {
      return outputDateFormatter.string(from: inputDate)
    } else {
      return nil
    }
  }
  
  func getFormattedDateFromDate(date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
  }
  
  func isEmptySetlist(_ setlist: Setlist) -> Bool {
    if setlist.sets?.setsSet?.isEmpty == true {
      return true
    }
    return false
  }
  
  func toggleLikeButton() {
    if self.isLikedArtist {
//      dataManager.deleteLikeArtist() // TODO: 좋아요 취소 어떻게 하는지 모르겠어요...
      self.isLikedArtist.toggle()
    } else {
      dataManager.addLikeArtist(
        name: self.artistInfo?.name ?? "",
        country: "",
        alias: self.artistInfo?.alias ?? "",
        mbid: self.artistInfo?.mbid ?? "",
        gid: self.artistInfo?.gid ?? 0,
        imageUrl: self.artistInfo?.imageUrl ?? "",
        songList: self.artistInfo?.songList ?? []
      )
      self.isLikedArtist.toggle()
    }
  }
}
