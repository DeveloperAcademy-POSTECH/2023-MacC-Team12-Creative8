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
      } else if bookmarkedSetlists.count > 1 {
        VStack {
          ScrollView(.horizontal) {
            HStack {
              ForEach(Array(bookmarkedSetlists.prefix(min(bookmarkedSetlists.count, 3))), id: \.self) { _ in
                setlistsLayer
                  .frame(width: UIWidth)
              }
            }
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
                  .frame(width: 8)
                  .foregroundStyle(Color(UIColor.systemGray))
                  .padding(.vertical)
                  .padding(.horizontal, 5)
              }
            }
          }
        }
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
    if !bookmarkedSetlists.isEmpty {
      scrollPosition = bookmarkedSetlists[0]
    }
  }
  
  private var emptyLayer: some View {
  SummarizedSetlistInfoView(
      type: .bookmarkedConcert,
      info: nil,
      infoButtonAction: nil,
      chevronButtonAction: nil
    )
  }
  
  private var setlistsLayer: some View {
    // TODO: vm.getFormattedDateFromDate() 오류 납니다...
    SummarizedSetlistInfoView(
      type: .bookmarkedConcert,
      info: SetlistInfo(
        artistInfo: vm.artistInfo,
        id: scrollPosition!.setlist.setlistId,
        date: vm.getFormattedDate(
          date: scrollPosition!.setlist.date,
          format: "yyyy년 MM월 dd일"
        ),
        title: scrollPosition!.setlist.title,
        venue: "\(scrollPosition!.setlist.venue)\n\(scrollPosition!.setlist.city), \(scrollPosition!.setlist.country)"
      ),
      infoButtonAction: nil,
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
