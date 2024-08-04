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
    Group {
      HStack {
        Text("찜한 아티스트")
          .font(.title).bold()
          .foregroundStyle(Color.mainBlack)
          .padding(.vertical)
          .frame(alignment: .leading)
        Spacer()
      }
      if likeArtists.isEmpty {
        IsEmptyCell(type: .likeArtist)
      } else {
        List {
          VStack(alignment: .leading, spacing: 0) {
            Text("상단 5명의 아티스트만 홈 화면에 표시됩니다\n변경을 원하신다면 순서를 옮겨보세요")
              .font(.footnote)
              .foregroundStyle(Color.gray)
              .padding(.bottom)
            
          }.id(topID)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.mainWhite)
          
          archiveArtistListCell
            .listRowSeparator(.hidden)
            .listRowBackground(Color.mainWhite)
        }
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .padding(EdgeInsets(top: -10, leading: -18, bottom: 10, trailing: -18))
        
      }
    }
    .padding(.horizontal, 24)
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
          .foregroundColor(Color.black)
      }
      if index == 4 {
        Divider()
          .background(Color.gray)
      }
    }
    .onMove { source, destination in
      var updatedItems = likeArtists
      updatedItems.move(fromOffsets: source, toOffset: destination)
      
      // Update CoreData context and save changes
      for (index, item) in updatedItems.enumerated() {
        item.orderIndex = likeArtists.count - 1 - index
      }
      // Assuming `modelContext` is available
      do {
        try modelContext.save()
      } catch {
        print("Failed to save context: \(error)")
      }
    }
  }
}
