//
//  NewMainViewModel.swift
//  Feature
//
//  Created by 장수민 on 11/17/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftUI
import Core

final class NewMainViewModel: ObservableObject {
  let dataService = SetlistDataService()
  let koreanConverter = KoreanConverter()
  
  @Published var selectedIndex: Int?
  @Published var scrollToIndex: Int?
  @Published var isTapped: Bool = false
  @Published var isLoading: Bool = false
  
  func replaceFirstSpaceWithNewline(_ input: String) -> String {
    guard let range = input.rangeOfCharacter(from: .whitespaces) else {
      return input
    }
    return input.replacingCharacters(in: range, with: "\n")
  }
}
