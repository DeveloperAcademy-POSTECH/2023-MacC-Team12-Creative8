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
      .background(Color.gray6)
      .navigationTitle("보관함")
      .navigationBarTitleDisplayMode(.large)
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
  
//  private func findArtistImageURL(byItem item: ArchivedConcertInfo) -> String {
//      if let url = likeArtists.first(where: { $0.artistInfo.mbid == item.artistInfo.mbid })?.artistInfo.imageUrl {
//          print("find " + item.artistInfo.name)
//          return url
//      } else {
//          print("cant find " + item.artistInfo.name)
//          return ""
//      }
//  }
  
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
          ForEach(Array(viewModel.artistSet).sorted(by: { $0.artistInfo.name < $1.artistInfo.name }), id: \.artistInfo.name) { artist in
            Button {
                if viewModel.selectArtist == artist.artistInfo.name {
                viewModel.selectArtist = ""
              } else {
                viewModel.selectArtist = artist.artistInfo.name
              }
            } label: {
                ArtistSetCell(name: artist.artistInfo.name, artistImgUrl: URL(string: artist.artistInfo.imageUrl), isSelected: viewModel.selectArtist.contains(artist.artistInfo.name))
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
        var colorToggle = true
        ForEach(concertInfo) { item in
            if viewModel.selectArtist.isEmpty || viewModel.selectArtist.contains(item.artistInfo.name) {
                let url = URL(string: item.artistInfo.imageUrl)
                let (backgroundColor, foregroundColor) = getColor(url: url, toggle: &colorToggle)
                
                ArchiveConcertInfoCell(
                    selectedTab: $selectedTab,
                    info: item,
                    url: url,
                    viewModel: viewModel, backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor
                )
//                .frame(width: UIWidth * 0.42)
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
  private func getColor(url: URL?, toggle: inout Bool) -> (Color, Color) {
    guard url == nil else {
      return (.clear, .clear)
    }
    //TODO: 색상 변경
      let backgroundColor: Color = toggle ? .orange100: .mainWhite
      let foregroundColor: Color = toggle ? .mainOrange : Color(UIColor.systemGray4)
      toggle.toggle()
    
    return (backgroundColor, foregroundColor)
  }
  
//  private var artistView: some View {
//    Group {
//      if likeArtists.isEmpty {
//        IsEmptyCell(type: .likeArtist)
//      } else {
//        ScrollViewReader { proxy in
//          List {
//            VStack(alignment: .leading, spacing: 0) {
//              Text("찜한 아티스트 중 상단의 5명이 메인화면에 등장합니다")
//                .font(.footnote)
//                .foregroundStyle(Color.fontGrey2)
//                .padding(.top)
//                .listRowBackground(Color.backgroundWhite)
//              Group {
//                Text("변경을 원하신다면 ")
//                  .font(.footnote)
//                  .foregroundStyle(Color.fontGrey2)
//                +
//                Text("아티스트를 꾹 눌러 순서를 옮겨보세요")
//                  .font(.footnote)
//                  .fontWeight(.semibold)
//                  .foregroundStyle(Color.fontGrey2)
//              }
//            }.id(topID)
//              .listRowSeparator(.hidden)
//              .listRowBackground(Color.backgroundWhite)
//            
//            artistListView
//              .listRowSeparator(.hidden)
//              .listRowBackground(Color.backgroundWhite)
//          }
//          .scrollIndicators(.hidden)
//          .listStyle(.plain)
//          .padding(EdgeInsets(top: -10, leading: -18, bottom: 10, trailing: -18))
//          .onReceive(tabViewManager.$scrollToTop) { _ in
//            withAnimation {
//              proxy.scrollTo(topID)
//            }
//          }
//        }
//      }
//    }
//    .padding(.horizontal, 24)
//  }
  
//  private var artistListView: some View {
//    ForEach(Array(likeArtists.enumerated()), id: \.element) { index, item in
//      HStack {
//        ArchiveArtistCell(artistUrl: URL(string: item.artistInfo.imageUrl), isNewUpdate: false)
//        Text("\(item.artistInfo.name)")
//          .font(.subheadline)
//          .foregroundStyle(index < 5 ? Color.mainOrange : Color.mainBlack)
//          .background(
//            NavigationLink(value: NavigationDelivery(artistInfo: SaveArtistInfo(name: item.artistInfo.name, country: "", alias: item.artistInfo.alias, mbid: item.artistInfo.mbid, gid: 0, imageUrl: "", songList: []))) {
//              Text("")
//            }
//              .opacity(0)
//          )
//        Spacer()
//        MenuButton(selectedTab: $selectedTab, item: item)
//      }
//    }
//    .onMove { source, destination in
//      var updatedItems = likeArtists
//      updatedItems.move(fromOffsets: source, toOffset: destination)
//      for (index, item) in updatedItems.enumerated() {
//        item.orderIndex = likeArtists.count - 1 - index
//      }
//    }
//  }
}
