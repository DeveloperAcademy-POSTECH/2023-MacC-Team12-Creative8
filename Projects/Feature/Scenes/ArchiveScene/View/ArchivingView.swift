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
import Combine

struct ArchivingView: View {
  @Binding var selectedTab: Tab
  @Query(sort: \LikeArtist.orderIndex, order: .reverse) var likeArtists: [LikeArtist]
  @Query(sort: \ArchivedConcertInfo.setlist.date, order: .reverse) var concertInfo: [ArchivedConcertInfo]
  @StateObject var viewModel = ArchivingViewModel.shared
  @StateObject var tabViewManager: TabViewManager
  @Namespace var topID
  
  var body: some View {
    NavigationStack(path: $tabViewManager.pageStack) {
      VStack {
        bookmarkView
      }
      .background(Color.gray)
      .navigationTitle("보관함")
      .navigationDestination(for: NavigationDelivery.self) { value in
        if value.setlistId != nil {
          SetlistView(setlistId: value.setlistId, artistInfo: ArtistInfo(
            name: value.artistInfo.name,
            alias: value.artistInfo.alias,
            mbid: value.artistInfo.mbid,
            gid: value.artistInfo.gid,
            imageUrl: value.artistInfo.imageUrl,
            songList: value.artistInfo.songList))
        } else {
          ArtistView(selectedTab: $selectedTab, artistName: value.artistInfo.name, artistAlias: value.artistInfo.alias, artistMbid: value.artistInfo.mbid)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    ArchivingView(selectedTab: .constant(.archiving), tabViewManager: .init(consecutiveTaps: Empty().eraseToAnyPublisher()))
  }
}

extension ArchivingView {
  private var bookmarkView: some View {
    Group {
      if concertInfo.isEmpty {
        IsEmptyCell(type: .bookmark)
      } else {
        ScrollViewReader { proxy in
          ScrollView {
            Spacer().id(topID)
            bookmarkListView
          }
          .scrollIndicators(.hidden)
          .onReceive(tabViewManager.$scrollToTop) { _ in
            withAnimation {
              proxy.scrollTo(topID)
            }
          }
        }
      }
    }
  }
  
  private func findArtistImageURL(byName name: String) -> String {
    if let url = likeArtists.first(where: { $0.artistInfo.name.localizedStandardContains(name) })?.artistInfo.imageUrl {
      return url
    } else {
      return ""
    }
  }
  
  private var bookmarkListView: some View {
    VStack {
      ScrollView(.horizontal) {
        HStack {
          Rectangle()
            .padding(2)
            .foregroundStyle(.clear)
          Button {
            viewModel.selectArtist = ""
          } label: {
            AllArtistsSetCell(name: "전체", isSelected: viewModel.selectArtist.isEmpty)
          }
          ForEach(viewModel.artistSet.sorted(), id: \.self) { artist in
            Button {
              if viewModel.selectArtist == artist {
                viewModel.selectArtist = ""
              } else {
                viewModel.selectArtist = artist
              }
            } label: {
              ArtistSetCell(name: artist, artistImgUrl: URL(string: findArtistImageURL(byName: artist)), isSelected: viewModel.selectArtist.contains(artist))
            }
          }
        }
      }
      .scrollIndicators(.hidden)
      .padding(.vertical)
      
      LazyVGrid(columns: [
        GridItem(.flexible(), spacing: 8, alignment: nil),
        GridItem(.flexible(), spacing: 8, alignment: nil)
      ], spacing: 16) {
        ForEach(concertInfo) { item in
          if viewModel.selectArtist.isEmpty || viewModel.selectArtist.contains(item.artistInfo.name) {
            ArchiveConcertInfoCell(selectedTab: $selectedTab, info: item, url: URL(string: item.artistInfo.imageUrl))
              .frame(width: UIWidth * 0.43)
          }
        }
      }
      .padding(.horizontal, 24)
    }
    .onAppear { viewModel.insertArtistSet(concertInfo) }
    .onChange(of: concertInfo) { _, newValue in
      viewModel.insertArtistSet(newValue)
    }
  }
}
