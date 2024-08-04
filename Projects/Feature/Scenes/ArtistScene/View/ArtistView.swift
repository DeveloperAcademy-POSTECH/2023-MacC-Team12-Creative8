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
          .frame(width: UIWidth, height: UIHeight)
      } else {
        ScrollView {
          ArtistInfoView(vm: vm)
          if vm.setlists?.count != 0 {
            BookmarkedSetlistsView(vm: vm, selectedTab: $selectedTab)
          }
          AllSetlistsView(vm: vm)
        }
      }
    }
    .padding(.horizontal, 5)
    .onAppear {
      if vm.artistInfo.gid == nil {
        vm.getArtistInfoFromGenius(artistName: artistName, artistAlias: artistAlias, artistMbid: artistMbid)
        vm.getSetlistsFromSetlistFM(artistMbid: artistMbid)
      }
    }
    .background(Color.gray6)
  }
}

#Preview {
//  NavigationStack {
//    ArtistView(selectedTab: .constant(.archiving), artistName: "IU", artistAlias: "아이유", artistMbid: "b9545342-1e6d-4dae-84ac-013374ad8d7c")
//  }
  NavigationStack {
    ArtistView(selectedTab: .constant(.archiving), artistName: "검정치마", artistAlias: "검정치마", artistMbid: "b9545342-1e6d-4dae-84ac-013374ad8d7c")
  }
//  NavigationStack {
//    ArtistView(selectedTab: .constant(.archiving), artistName: "커피소년", artistAlias: "커피소년", artistMbid: "5a9ef9b7-7581-4f64-a9e4-7b5c7bde0555")
//  }
}
