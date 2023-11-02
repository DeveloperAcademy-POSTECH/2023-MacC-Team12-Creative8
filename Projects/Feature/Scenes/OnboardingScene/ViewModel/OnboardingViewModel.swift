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
  
  @Published var model: [OnboardingModel] = []
  @Published var genres = ["케이팝", "힙합", "밴드", "인디", "발라드", "해외가수"]
  @Published var isGenreSelected = false
  @Published var isArtistselected = false
  @Published var isShowToastBar = false
  @Published var artistSelectedCount = 0
  
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
              model = (worksheet.data?.rows.map { row in
                guard let name = row.cells[safe: 0]?.stringValue(sharedString), !name.isEmpty else {
                    return nil
                }
                let mbid = row.cells[safe: 1]?.stringValue(sharedString) ?? ""
                let filters = row.cells.dropFirst(2).compactMap { $0.stringValue(sharedString) }
                print(OnboardingModel(name: name, mbid: mbid, filters: filters))

                return OnboardingModel(name: name, mbid: mbid, filters: filters)
              }.compactMap { $0 })!
              
            }
          }
        }
      } catch {
        print(error)
      }
    }
  }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
