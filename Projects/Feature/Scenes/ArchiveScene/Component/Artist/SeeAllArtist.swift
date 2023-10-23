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
  var body: some View {
    ScrollView {
      ForEach(likeArtist) { item in
        HStack {
          ArchiveArtistCell(artistUrl: URL(string: item.artistInfo.imageUrl)!, isNewUpdate: false)
          Text("\(item.artistInfo.name)")
            .foregroundStyle(Color.fontBlack)
          Spacer()
          Button {
              
          } label: {
            Image(systemName: "ellipsis")
              .foregroundStyle(Color.fontBlack)
              .rotationEffect(.degrees(-90))
          }
        }
      }
    }
    .padding()
    .navigationTitle("좋아요한 아티스트")
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  SeeAllArtist()
}
