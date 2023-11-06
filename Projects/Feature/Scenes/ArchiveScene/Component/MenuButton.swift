//
//  MenuButton.swift
//  Feature
//
//  Created by A_Mcflurry on 11/1/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI

struct MenuButton: View {
  @Binding var selectedTab: Tab
  let item: LikeArtist
  @StateObject var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  var body: some View {
    Menu {
      NavigationLink("아티스트 보기") { ArtistView(selectedTab: $selectedTab, artistName: item.artistInfo.name, artistAlias: item.artistInfo.alias, artistMbid: item.artistInfo.mbid) }
      Button("찜하기 취소") { dataManager.deleteLikeArtist(item) }
    } label: {
      Image(systemName: "ellipsis")
        .foregroundStyle(Color.mainBlack)
        .padding()
        .background(Color.clear)
    }
    .onAppear { dataManager.modelContext = modelContext }
  }
}