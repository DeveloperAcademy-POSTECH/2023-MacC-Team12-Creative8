//
//  ArchivingArtistView.swift
//  Feature
//
//  Created by 최효원 on 7/31/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI
import Combine

struct ArchivingArtistView: View {
  @Query(sort: \LikeArtist.orderIndex, order: .reverse) var likeArtists: [LikeArtist]
  @Query(sort: \ArchivedConcertInfo.setlist.date, order: .reverse) var concertInfo: [ArchivedConcertInfo]
  @StateObject var viewModel = ArchivingViewModel.shared
  @Environment(\.modelContext) var modelContext
  @Namespace var topID
  
  var body: some View {
    ZStack {
      Color.gray6.ignoresSafeArea()
      VStack {
        HStack {
          Text("찜한 아티스트")
            .font(.title).bold()
            .foregroundStyle(Color.mainBlack)
            .padding([.leading, .top], 23)
          Spacer()
        }
        .padding(.bottom, -5)
        
        if likeArtists.isEmpty {
          IsEmptyCell(type: .likeArtist)
        } else {
          List {
            VStack(alignment: .leading) {
                Group {
                  Text("상단 5명의 아티스트만 홈 화면에 표시됩니다\n")
                  Text("변경을 원하신다면 순서를 옮겨보세요")
                }
                .font(.footnote)
                .foregroundStyle(Color.gray)
                .padding(.bottom, 6)
              
            }.id(topID)
              .listRowSeparator(.hidden)
              .listRowBackground(Color.gray6)
            
            archiveArtistListCell
              .listRowSeparator(.hidden)
              .listRowBackground(Color.gray6)
          }
          .padding(.horizontal, 5)
          .scrollIndicators(.hidden)
          .listStyle(.plain)
          
        }
      }
    }
  }
  
  private var archiveArtistListCell: some View {
    ForEach(Array(likeArtists.enumerated()), id: \.element) { index, item in
      HStack(spacing: 16) {
        ArchiveArtistCellImage(artistUrl: URL(string: item.artistInfo.imageUrl))
        Text(item.artistInfo.name)
          .font(.subheadline)
          .foregroundStyle(index < 5 ? Color.mainOrange : Color.mainBlack)
          .bold(index < 5)
        Spacer()
        Image(systemName: "chevron.up.chevron.down")
          .foregroundColor(.mainBlack)
      }
      if index == 4 {
        Divider()
          .background(Color(UIColor.systemGray3))
      }
    }
    .onMove { source, destination in
      var updatedItems = likeArtists
      updatedItems.move(fromOffsets: source, toOffset: destination)
      
      for (index, item) in updatedItems.enumerated() {
        item.orderIndex = likeArtists.count - 1 - index
      }

        do {
        try modelContext.save()
      } catch {
        print("Failed to save context: \(error)")
      }
    }
  }
}
