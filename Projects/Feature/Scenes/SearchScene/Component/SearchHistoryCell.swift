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

struct SearchHistoryCell: View {
  @Binding var searchText: String
  let history: SearchHistory
  let dateFormatter = DateFormatter.monthDayFormatter()
  let dataManager: SwiftDataManager

    var body: some View {
      HStack {
        NavigationLink {
          ArtistView(artistName: history.artistInfo.name, artistAlias: history.artistInfo.alias, artistMbid: history.artistInfo.mbid)
        } label: {
          ListRow(namePair: (history.artistInfo.name, ""), info: history.artistInfo.country)
        }
        .foregroundStyle(.black)

        Spacer()

        Button {
          dataManager.deleteSearchHistory(history)
        } label: {
          Image(systemName: "xmark").foregroundStyle(.gray)
        }
      }
      .padding(.top)
    }
}
