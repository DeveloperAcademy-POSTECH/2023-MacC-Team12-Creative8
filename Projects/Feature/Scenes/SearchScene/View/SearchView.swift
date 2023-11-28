//
//  SearchView.swift
//  Feature
//
//  Created by 최효원 on 10/7/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import Core
import SwiftData
import UI

struct SearchView: View {
  @Binding var selectedTab: Tab
  @Query(sort: \SearchHistory.createdDate, order: .reverse) private var history: [SearchHistory] = []
  @StateObject var viewModel = SearchViewModel()
  @Environment (\.modelContext) var modelContext
  @StateObject var dataManager = SwiftDataManager()
  @StateObject var tabViewManager: TabViewManager
  @Namespace var topID
  
  var body: some View {
    NavigationStack(path: $tabViewManager.pageStack) {
      VStack(spacing: 0) {
        SearchBar(text: $viewModel.searchText, isEditing: $viewModel.searchIsPresented)
          .padding(.top)
          .padding(.top)
          ScrollViewReader { proxy in
            ScrollView {
              Spacer().id(topID)
              artistView
            }
            .onReceive(tabViewManager.$scrollToTop) { _ in
              withAnimation {
                proxy.scrollTo(topID)
              }
            }
          }
          .scrollDisabled(viewModel.searchIsPresented)
          .scrollIndicators(.hidden)
          .overlay {
            if viewModel.searchIsPresented {
              ScrollView {
                searchingHistoryView
                  .padding(.top, 32)
              }
              .scrollIndicators(.hidden)
            }
          }
      }
      .padding(.horizontal)
      .background(Color.backgroundWhite)
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
  
  private var artistView: some View {
    VStack(alignment: .leading) {
      domesticArtistView
        .padding(.vertical, 64)
      foreignArtistView
        .padding(.bottom, 48)
    }
    .background(Color.backgroundWhite)
    .disabled(viewModel.searchIsPresented)
    .opacity(viewModel.searchIsPresented ? 0 : 1)
  }
  
  private var domesticArtistView: some View {
    VStack(alignment: .leading) {
      Text("국내 아티스트").bold()
        .foregroundStyle(Color.mainBlack)
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
        ForEach(viewModel.getRandomArtists(.kpop), id: \.self) { item in
          SearchArtistCell(selectedTab: $selectedTab, imageURL: item.url ?? "", artistName: item.name, artistMbid: item.mbid)
        }
      }
    }
  }
  
  private var foreignArtistView: some View {
    VStack(alignment: .leading) {
      Text("해외 아티스트").bold()
        .foregroundStyle(Color.mainBlack)
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
        ForEach(viewModel.getRandomArtists(.pop), id: \.self) { item in
          SearchArtistCell(selectedTab: $selectedTab, imageURL: item.url ?? "", artistName: item.name, artistMbid: item.mbid)
        }
      }
    }
  }
  
  private var searchingHistoryView: some View {
        VStack {
          if viewModel.searchText.isEmpty {
            HStack {
              Text("최근 검색")
                .bold()
                .foregroundStyle(Color.mainBlack)
              Spacer()
              Button {
                dataManager.deleteSearchHistoryAll()
              } label: {
                Text("모두 지우기")
                  .foregroundStyle(Color.mainOrange)
                  .bold()
              }
            }
            ForEach(history, id: \.self) { item in
              SearchHistoryCell(searchText: $viewModel.searchText, selectedTab: $selectedTab, history: item, dataManager: dataManager)
            }
            .toolbar(viewModel.searchIsPresented ? .hidden : .visible, for: .tabBar)
          } else {
            SearchArtistList(selectedTab: $selectedTab, viewModel: viewModel)
          }
        }
      .onAppear {
        dataManager.modelContext = modelContext
      }
      .opacity(viewModel.searchIsPresented ? 1 : 0)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
}
