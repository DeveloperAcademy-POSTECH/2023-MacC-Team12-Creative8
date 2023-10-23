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

class OnboardingViewModel: ObservableObject {
  let genres = ["K-pop", "힙합", "밴드", "인디", "발라드", "해외가수"]
  
  var artists: [String] = ["아이유", "Young K", "Charlie Puth", "The Kid LALOI", "Kings of Convenience", "Jerome Bell", "Post Malone", "Kristin Watson", "너드커넥션", "버스커버스커", "그린 토마토 후라이드", "달빛요정역전만루홈런", "아이유", "Young K", "Charlie Puth", "The Kid LALOI", "Kings of Convenience", "Jerome Bell", "Post Malone", "Kristin Watson", "너드커넥션", "버스커버스커", "그린 토마토 후라이드", "달빛요정역전만루홈런", "아이유", "Young K", "Charlie Puth", "The Kid LALOI", "Kings of Convenience", "Jerome Bell", "Post Malone", "Kristin Watson", "너드커넥션", "버스커버스커", "그린 토마토 후라이드", "달빛요정역전만루홈런"]
}

class OpenXlsx: ObservableObject {
  
  public var fileName: String
  public var fileType: String
  public var filePath: String?
  
  init(fileName: String, fileType: String, filePath: String?) {
    self.fileName = fileName
    self.fileType = fileType
    self.filePath = Bundle.main.path(forResource: fileName, ofType: fileType)
  }
  
  convenience init() {
    self.init(fileName: "test", fileType: "xlsx", filePath: nil)
  }
  
  func openXlsxTest() {
    if let fpath = self.filePath {
      guard let file = XLSXFile(filepath: fpath) else {
        fatalError("XLSX file at \(String(describing: self.filePath)) is corrupted or does not exist")
      }
      
      do {// 파일에서 excel의 통합문서를 지칭하는 workbook을 배열로 반환합니다. 여기서는 test.xlsx
        for wbk in try file.parseWorkbooks() {
          // workbook에서 sheet의 이름과 그 경로를 순환하며 name과 path 변수에 반환합니다.
          for (name, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
            
            if let worksheetName = name {
              // workbook에 있는 모든 sheet의 이름을 출력합니다.
              print("\(worksheetName)")
            }
            // sheet의 경로(path)를 이용하여 해당 sheet를 worksheet 변수에 반환합니다.
            let worksheet = try file.parseWorksheet(at: path)
            // 아래의 세 줄이 sheet별 A열에 해당하는 값을 배열로 반환합니다.
            if let sharedString = try file.parseSharedStrings() {
              let columnCString = worksheet.cells(atColumns: [ColumnReference("B")!])
                .compactMap {$0.stringValue(sharedString)}
              // 해당 sheet의 A열에 해당 하는 값들 출력
              print(columnCString)
            }
          }
        }
      }
      catch {
        print(error)
      }
    }
  }
}
