//
//  SeeAllArtist.swift
//  Feature
//
//  Created by A_Mcflurry on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData
import Core

struct SeeAllArtist: View {
  @Query var likeArtist: [LikeArtist]
  @StateObject var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  var body: some View {
    ScrollView {
      ForEach(likeArtist) { item in
        HStack {
          ArchiveArtistCell(artistUrl: URL(string: item.artistInfo.imageUrl)!, isNewUpdate: false)
          Text("\(item.artistInfo.name)")
          Spacer()
          Menu {
            NavigationLink("아티스트로 가기") { ArtistView(artistName: item.artistInfo.name, artistAlias: item.artistInfo.alias, artistMbid: item.artistInfo.mbid) }
            Button("좋아요 취소") { dataManager.deleteLikeArtist(item) }
          } label: {
            Image(systemName: "ellipsis")
              .foregroundStyle(.black)
              .rotationEffect(.degrees(-90))
              .padding(.horizontal)
              .background(Color.clear)
          }
        }
      }
      .onAppear { dataManager.modelContext = modelContext }
    }
    .padding()
    .navigationTitle("좋아요한 아티스트")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  SeeAllArtist()
}
