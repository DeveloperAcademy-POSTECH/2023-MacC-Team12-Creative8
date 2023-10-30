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
  
  var artistInfo: ArtistInfo?
  var bookmarkedSetlists: [Setlist]?
  var setlists: [Setlist]?
  var page: Int = 1
  var totalPage: Int = 0
  
  @Published var showBookmarkedSetlists: Bool
  @Published var isLoading1: Bool
  @Published var isLoading2: Bool
  @Published var isLoading3: Bool
  @Published var image: UIImage?

  init() {
    self.showBookmarkedSetlists = false
    self.isLoading1 = false
    self.isLoading2 = false
    self.isLoading3 = false
    self.image = nil
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
    if let url = URL(string: self.artistInfo?.imageUrl ?? "") {
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
  }

  func getFormattedDate(date: String) -> String? {
    let inputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd-MM-yyyy"
      return formatter
    }()
    
    let outputDateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM.dd"
      return formatter
    }()
    
    if let inputDate = inputDateFormatter.date(from: date) {
      return outputDateFormatter.string(from: inputDate)
    } else {
      return nil
    }
  }
  
}
