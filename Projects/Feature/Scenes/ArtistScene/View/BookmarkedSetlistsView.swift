//
//  BookmarkedSetlistsView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

struct BookmarkedSetlistsView: View {
  @ObservedObject var vm: ArtistViewModel
  @Query var concertInfo: [ArchivedConcertInfo]
  @State var bookmarkedSetlists: [ArchivedConcertInfo] = []
  @Environment(\.dismiss) var dismiss
  @Binding var selectedTab: Tab
  
  var body: some View {
    VStack {
      if bookmarkedSetlists.isEmpty {
        emptyLayer
      } else {
        setlistsLayer
      }
    }
    .padding(.bottom)
    .onAppear { getBookmarkedSetlists() }
  }
  
  private func getBookmarkedSetlists() {
    bookmarkedSetlists = []
    for concert in concertInfo {
      if concert.artistInfo.mbid == vm.artistInfo.mbid {
        bookmarkedSetlists.append(concert)
      }
    }
  }
  
  private var emptyLayer: some View {
    SummarizedSetlistInfoView(
      type: .bookmarkedConcert,
      info: nil,
      infoButtonAction: nil,
      cancelBookmarkAction: nil,
      chevronButtonAction: nil
    )
  }
  
  private var setlistsLayer: some View {
    SummarizedSetlistInfoView(
      type: .bookmarkedConcert,
      info: SetlistInfo(
        artistInfo: vm.artistInfo,
        id: bookmarkedSetlists[0].setlist.setlistId,
        date: vm.getFormattedDate(
          date: bookmarkedSetlists[0].setlist.date,
          format: "yyyy년 MM월 dd일"
        ),
        title: bookmarkedSetlists[0].setlist.title,
        venue: "\(bookmarkedSetlists[0].setlist.venue)\n\(bookmarkedSetlists[0].setlist.city), \(bookmarkedSetlists[0].setlist.country)"
      ),
      infoButtonAction: nil,
      cancelBookmarkAction: {
        vm.swiftDataManager.deleteArchivedConcertInfo(bookmarkedSetlists[0])
        for (index, item) in bookmarkedSetlists.enumerated() {
          if item.id == bookmarkedSetlists[0].id {
            bookmarkedSetlists.remove(at: index)
          }
        }
      },
      chevronButtonAction: {
        vm.archivingViewModel.selectSegment = .bookmark
        vm.archivingViewModel.selectArtist = vm.artistInfo.name
        if selectedTab == .archiving {
          dismiss()
        } else {
          selectedTab = .archiving
        }
      }
    )
  }
}

#Preview {
  BookmarkedSetlistsView(vm: ArtistViewModel(), selectedTab: .constant(.archiving))
}
