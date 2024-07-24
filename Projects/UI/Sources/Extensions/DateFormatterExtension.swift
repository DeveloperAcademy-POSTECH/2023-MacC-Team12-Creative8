//
//  DateFormaterExtension.swift
//  UI
//
//  Created by A_Mcflurry on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

public extension DateFormatter {
  static func dateMonthFormatter() -> DateFormatter {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM.dd"
      return formatter
  }
  
  static func yearFormatter() -> DateFormatter {
      let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "ko_KR")
      formatter.dateFormat = "YYYY"
      return formatter
  }
  
  static func dateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "YYYY년 MM월 dd일"
    return formatter
  }
}
