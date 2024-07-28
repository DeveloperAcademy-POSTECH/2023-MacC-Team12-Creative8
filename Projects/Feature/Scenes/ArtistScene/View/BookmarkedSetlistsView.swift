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
  @State private var scrollPosition: ArchivedConcertInfo?
  
  var body: some View {
    VStack {
      if bookmarkedSetlists.isEmpty {
        emptyLayer
          .frame(width: UIWidth * 0.87)
      } else if bookmarkedSetlists.count > 1 {
        VStack {
          ScrollView(.horizontal) {
            HStack {
              ForEach(Array(bookmarkedSetlists.prefix(min(bookmarkedSetlists.count, 3))), id: \.self) { element in
                setlistsLayer
                  .padding(.horizontal, UIWidth * 0.007)
                  .frame(width: UIWidth * 0.87)
              }
            }
            .padding(.horizontal, UIWidth * 0.13 / 2)
            .scrollTargetLayout()
          }
          .scrollTargetBehavior(.viewAligned)
          .scrollPosition(id: $scrollPosition)
          .scrollIndicators(.hidden)
          
          HStack {
            ForEach(Array(bookmarkedSetlists.prefix(min(bookmarkedSetlists.count, 3))), id: \.self) { element in
              if element == scrollPosition {
                RoundedRectangle(cornerRadius: 25.0)
                  .frame(width: 15, height: 8)
                  .foregroundStyle(Color.mainBlack)
                  .padding(.vertical)
                  .padding(.horizontal, 5)
              } else {
                Circle()
                  .frame(width: 10)
                  .foregroundStyle(Color.gray)
                  .padding(.vertical)
                  .padding(.horizontal, 5)
              }
            }
          }
        }
      } else {
        setlistsLayer
          .frame(width: UIWidth * 0.87)
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
    if !bookmarkedSetlists.isEmpty {
      scrollPosition = bookmarkedSetlists[0]
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
        id: scrollPosition!.setlist.setlistId,
        date: vm.getFormattedDateFromDate(
          date: scrollPosition!.setlist.date,
          format: "yyyy년 MM월 dd일"
        ),
        title: scrollPosition!.setlist.title,
        venue: "\(scrollPosition!.setlist.venue)\n\(scrollPosition!.setlist.city), \(scrollPosition!.setlist.country)"
      ),
      infoButtonAction: nil,
      cancelBookmarkAction: {
        vm.swiftDataManager.deleteArchivedConcertInfo(scrollPosition!)
        for (index, item) in bookmarkedSetlists.enumerated() {
          if item.id == scrollPosition!.id {
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
  ZStack {
    Color.gray.ignoresSafeArea()
    BookmarkedSetlistsView(vm: ArtistViewModel(), selectedTab: .constant(.archiving))
  }
}
