//
//  SearchHistoryCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

// 제발 제발 제발
struct SearchHistoryCell: View {
  @Binding var searchText: String
  let dataManager: SearchHistoryManager
  let history: SearchHistory
  let dateFormatter = DateFormatter.monthDayFormatter()

    var body: some View {
      HStack {
        Button("\(history.searchText)") {
          searchText = history.searchText
        }
        .foregroundStyle(.black)

        Spacer()

        Text("\(dateFormatter.string(from: history.searchDate))").foregroundStyle(.gray)

        Button {
          dataManager.deleteItems(item: history)
        } label: {
          Image(systemName: "xmark").foregroundStyle(.secondary)
        }
      }
      .padding(.top)
    }
}
