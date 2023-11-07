//
//  ArtistView.swift
//  Feature
//
//  Created by 고혜지 on 10/21/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI
 
struct ArtistView: View {
  @StateObject var vm = ArtistViewModel()
  @Binding var selectedTab: Tab
  let artistName: String
  let artistAlias: String?
  let artistMbid: String
  
  var body: some View {
    VStack {
      if vm.isLoadingArtistInfo || vm.isLoadingSetlist {
        ProgressView()
      } else {
        ScrollView {
          ArtistInfoView(vm: vm)
          BookmarkedSetlistsView(vm: vm, selectedTab: $selectedTab)
          AllSetlistsView(vm: vm)
        }
      }
    }
    .background(Color.backgroundWhite)
    .toolbar { ToolbarItem(placement: .principal) { toolbarArtistName } }
    .onAppear {
      vm.getArtistInfoFromGenius(artistName: artistName, artistAlias: artistAlias, artistMbid: artistMbid)
      vm.getSetlistsFromSetlistFM(artistMbid: artistMbid)
    }
  }
  
  private var toolbarArtistName: some View {
    Text(vm.artistInfo.name)
      .font(.title3)
      .fontWeight(.semibold)
  }
}

#Preview {
  NavigationStack {
    ArtistView(selectedTab: .constant(.archiving), artistName: "IU", artistAlias: "아이유", artistMbid: "b9545342-1e6d-4dae-84ac-013374ad8d7c")
  }
//  ArtistView(selectedTab: .constant(.archiving), artistName: "검정치마", artistAlias: "검정치마", artistMbid: "b9545342-1e6d-4dae-84ac-013374ad8d7c")
}
