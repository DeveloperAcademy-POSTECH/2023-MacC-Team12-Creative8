//
//  OnboardingViewModel.swift
//  Feature
//
//  Created by 예슬 on 2023/10/22.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Foundation
import CoreXLSX
import Core

final class OnboardingViewModel: ObservableObject {
  
  private var fileName: String
  private var fileType: String
  private var filePath: String?
  @Published var allArtist: [OnboardingModel] = []
  @Published var filteredArtist: [OnboardingModel] = []
  @Published var selectedArtist: [OnboardingModel] = []
  
  @Published var selectedGenere: OnboardingFilterType = .all
  @Published var isShowToastBar = false
  @Published var artistSelectedCount = 0
  
  private let artistDataManager: ArtistDataManager = ArtistDataManager.shared
  private let dataService: SetlistDataService = SetlistDataService.shared
  var artistInfo: ArtistInfo?
  private var setlists: [Setlist]?
  private var page: Int = 1
  private var totalPage: Int = 0
  @ObservedObject var dataManager = SwiftDataManager()
  @AppStorage("isOnboarding") var isOnboarding: Bool?
  
  init(fileName: String, fileType: String, filePath: String?) {
    self.fileName = fileName
    self.fileType = fileType
    self.filePath = Bundle.main.path(forResource: fileName, ofType: fileType)
  }
  
  convenience init() {
    self.init(fileName: "onboardingArtist", fileType: "xlsx", filePath: nil)
  }
  
  func readXslx() {
    if let fpath = self.filePath {
      guard let file = XLSXFile(filepath: fpath) else {
        fatalError("XLSX file at \(String(describing: self.filePath)) is corrupted or does not exist")
      }
      
      do {
        for wbk in try file.parseWorkbooks() {
          for (_, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
            let worksheet = try file.parseWorksheet(at: path)
            if let sharedString = try file.parseSharedStrings() {
              allArtist = (worksheet.data?.rows.compactMap { row -> OnboardingModel? in
                guard let name = row.cells[safe: 0]?.stringValue(sharedString), !name.isEmpty,
                      let mbid = row.cells[safe: 1]?.stringValue(sharedString),
                      let geniusString = row.cells[safe: 2]?.stringValue(sharedString),
                      let genius = Int(geniusString),
                      let filter = row.cells[safe: 3]?.stringValue(sharedString) else {
                  return nil
                }
                return OnboardingModel(name: name, genius: genius, mbid: mbid, filter: filter)
              })!
            }
          }
        }
      } catch {
        print(error)
      }
      
    }
  }
  
  func artistSelectionAction(at index: Int) {
    let selectedModel = filteredArtist[index]
    
    if let existingIndex = selectedArtist.firstIndex(where: { $0.id == selectedModel.id }) {
      // If the model is already selected, remove it
      selectedArtist.remove(at: existingIndex)
      artistSelectedCount -= 1
    } else {
      // If the model is not selected, add it
      selectedArtist.append(selectedModel)
      artistSelectedCount += 1
    }
    
  }
  
  func getFilteredModels() -> [OnboardingModel] {
    return allArtist.filter { $0.filter == selectedGenere.rawValue }
  }
  
  func updateFilteredModels() {
    if selectedGenere == .all {
      filteredArtist = allArtist
    } else {
      filteredArtist = getFilteredModels()
    }
  }
  
  func getArtistInfoFromGenius(selectedArtists: [OnboardingModel]) async {
    for index in 0..<selectedArtists.count {
      if self.artistInfo == nil {
        artistDataManager.getArtistInfo(artistName: selectedArtists[index].name, artistAlias: "", artistMbid: selectedArtists[index].mbid) { result in
          if let result = result {
            //          DispatchQueue.main.async {
            self.dataManager.addLikeArtist(
              name: result.name,
              country: "",
              alias: result.alias ?? "",
              mbid: result.mbid,
              gid: result.gid ?? 0,
              imageUrl: result.imageUrl,
              songList: []
            )
            self.isOnboarding = false
            //          }
          }
        }
      }
    }
  }
  
  func getSetlistFromSetlistFM(selectedArtists: [OnboardingModel], index: Int) {
    if self.setlists == nil {
      dataService.fetchSetlistsFromSetlistFM(artistMbid: selectedArtists[index].mbid, page: page) { result in
        if let result = result {
          DispatchQueue.main.async {
            self.setlists = result.setlist
            self.totalPage = Int((result.total ?? 1) / (result.itemsPerPage ?? 1) + 1)
            
          }
        }
      }
    }
  }
}

// array nil 분기 처리
extension Array {
  subscript (safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
