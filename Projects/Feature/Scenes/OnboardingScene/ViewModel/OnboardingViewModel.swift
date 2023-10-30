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

final class OnboardingViewModel: ObservableObject {
  
  private var fileName: String
  private var fileType: String
  private var filePath: String?
  
  @Published var artistName = []
  @Published var genres = ["K-pop", "힙합", "밴드", "인디", "발라드", "해외가수"]
  @Published var isGenreSelected = false
  init(fileName: String, fileType: String, filePath: String?) {
    self.fileName = fileName
    self.fileType = fileType
    self.filePath = Bundle.main.path(forResource: fileName, ofType: fileType)
  }
  
  convenience init() {
    self.init(fileName: "test", fileType: "xlsx", filePath: nil)
  }
  
  func readXslx() {
    if let fpath = self.filePath {
      guard let file = XLSXFile(filepath: fpath) else {
        fatalError("XLSX file at \(String(describing: self.filePath)) is corrupted or does not exist")
      }
      
      do {// 파일에서 excel의 통합문서를 지칭하는 workbook을 배열로 반환
        for wbk in try file.parseWorkbooks() {
          // workbook에서 sheet의 이름과 그 경로를 순환하며 name과 path 변수에 반환
          for (_, path) in try file.parseWorksheetPathsAndNames(workbook: wbk) {
            
            // sheet의 경로(path)를 이용하여 해당 sheet를 worksheet 변수에 반환
            let worksheet = try file.parseWorksheet(at: path)
            // 아래의 세 줄이 sheet별 A열에 해당하는 값을 배열로 반환합니다.
            if let sharedString = try file.parseSharedStrings() {
              artistName = worksheet.cells(atColumns: [ColumnReference("B")!])
                .compactMap {$0.stringValue(sharedString)}
            }
          }
        }
      } catch {
        print(error)
      }
    }
  }
}
