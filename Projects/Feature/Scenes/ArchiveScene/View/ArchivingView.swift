//
//  ArchivingView.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData

struct ArchivingView: View {
  @Query var likeArtist: [LikeArtist]
  @Query var concertInfo: [ArchivedConcertInfo]

  var body: some View {
    VStack(alignment: .leading) {
      archivingArtistView
      blockView
    }
    .padding()
    .edgesIgnoringSafeArea(.bottom)
    .toolbar {
      ToolbarItem(placement: .topBarLeading) { Text("아카이빙").font(.title) }
    }
  }

  private var archivingArtistView: some View {
    ScrollView(.horizontal) {
      HStack {
        if likeArtist.count == 0 { emptyLikeCell }
        if likeArtist.count > 1 { seeAllCell }
        likedArtistCell
      }
    }
    .scrollIndicators(.hidden)
    .disabled(likeArtist.isEmpty)
  }

  private var seeAllCell: some View {
    NavigationLink {
      SeeAllArtist()
    } label: {
      VStack {
        RoundedRectangle(cornerRadius: 20)
          .foregroundStyle(.black)
          .frameForCell()
          .overlay {
            Text("All")
              .foregroundStyle(.white)
          }
        Text("전체보기")
          .foregroundStyle(.black)
      }
    }
  }

  private var emptyLikeCell: some View {
      VStack {
        RoundedRectangle(cornerRadius: 20)
          .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
          .frameForCell()
          .overlay {
            Image(systemName: "heart")
          }
        Text("좋아요한 아티스트")
          .font(.system(size: 12))
      }
      .frameForCell()
  }

  private var likedArtistCell: some View {
    ForEach(likeArtist) { item in
      VStack {
        NavigationLink {

        } label: {
          ArchiveArtistCell(artistUrl: item.artistImage, isNewUpdate: false)
        }
        Text("\(item.artistName)")
      }
    }
  }

  private var blockView: some View {
    Group {
      if concertInfo.isEmpty {
        blockIsEmptyView
      } else {
        ArchivingConcertBlockView()
      }
    }
  }

  private var blockIsEmptyView: some View {
    VStack {
      Image(systemName: "bookmark")
        .font(.largeTitle)
      Text("찜한 공연이 없어요")
        .font(.system(size: 16))
        .fontWeight(.semibold)
      Text("내가 좋아하는 아티스트의 공연을 찜하고\n세트리스트를 확인해보세요")
        .multilineTextAlignment(.center)
        .font(.system(size: 13))
    }
  }
}

#Preview {
  ArchivingView()
    .modelContainer(for: LikeArtist.self, inMemory: false)
}
