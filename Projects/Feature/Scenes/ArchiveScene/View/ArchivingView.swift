//
//  ArchivingView.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

struct ArchivingView: View {
  @Query var likeArtist: [LikeArtist]
  @Query var concertInfo: [ArchivedConcertInfo]
  @ObservedObject var dataManager = SwiftDataManager()
  @ObservedObject var vieWModel = ArchiveViewModel()
  @Environment(\.modelContext) var modelContext

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Text("아카이빙")
          .font(.title)
          .fontWeight(.semibold)
          .foregroundStyle(Color.fontBlack)
        archivingArtistView
        viewSelect
      }
    }
    .scrollIndicators(.hidden)
    .padding()
    .edgesIgnoringSafeArea(.bottom)
    .onAppear { dataManager.modelContext = modelContext }
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
      Text("찜한 아티스트")
        .font(.system(size: 12))
        .padding(.top, 5)
    }
    .foregroundStyle(Color.fontBlack)
  }
  
  private var likedArtistCell: some View {
    ForEach(likeArtist) { item in
      VStack {
        NavigationLink {
          ArtistView(artistName: item.artistInfo.name, artistAlias: item.artistInfo.alias, artistMbid: item.artistInfo.mbid)
        } label: {
          ArchiveArtistCell(artistUrl: URL(string: item.artistInfo.imageUrl)!, isNewUpdate: false)
        }
        Text("\(item.artistInfo.name)")
      }
    }
  }

  private var blockIsEmptyView: some View {
    VStack {
      Spacer(minLength: 175)
      Text("다시 듣기한 공연이 없어요")
        .font(.system(size: 16))
        .fontWeight(.semibold)
        .foregroundStyle(Color.fontBlack)
      Spacer()
      Text("내가 좋아하는 아티스트의 공연을 다시 듣기하고\n세트리스트를 확인해보세요")
        .multilineTextAlignment(.center)
        .font(.system(size: 13))
        .foregroundStyle(Color.fontGrey2)
    }
  }

  private var viewSelect: some View {
    VStack(spacing: 0) {
      viewPicker
        .padding(.bottom)
      if concertInfo.isEmpty {
        blockIsEmptyView
      } else {
        if vieWModel.userSelection == vieWModel.options[1] {
          ArchivingConcertBlockView()
        } else {
          ConcertListView()
        }
      }
    }
  }

  private var viewPicker: some View {
    HStack {
      Text("공연 다시 듣기")
        .font(.title3)
        .bold()
        .foregroundStyle(Color.fontBlack)
      Spacer()
      Picker("Form Selection", selection: $vieWModel.userSelection) {
        ForEach(vieWModel.options, id: \.self) {
          Image(systemName: $0)
        }
      }
      .pickerStyle(.segmented)
      .frame(width: UIWidth * 0.3)
    }
    .padding([.vertical, .top])
  }
}

#Preview {
  ArchivingView()
//    .modelContainer(for: LikeArtist.self, inMemory: false)
//    .modelContainer(for: ArchivedConcertInfo.self, inMemory: false)
}
