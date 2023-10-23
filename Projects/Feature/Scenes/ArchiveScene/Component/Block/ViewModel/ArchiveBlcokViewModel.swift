//
//  ArchiveBlcokViewModel.swift
//  Feature
//
//  Created by A_Mcflurry on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

final class ArchiveViewModel: ObservableObject {
  @Published var concertCellInfo: [(Int, Int)] = []
  @Published var maxminCnt: (Int, Int) = (0, 0)
  @Published var selecteYear: Int = 0
  @Published var artistUnique: [String] = []
  @Published var isActiveButton: Bool = false

  @Published var userSelection = "music.note.list"
  let options = ["music.note.list", "batteryblock"]
  // 월.일 형태
  let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM.dd"
    return formatter
  }()
  // 요일 형태
  let dayOfWeekFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "E"
    return formatter
  }()
}
