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

  var body: some View {
    ScrollViewReader { proxy in
      Group {
        headView
        ScrollView {
          searchingHistoryView
          //          artistView
        }
      }
      .padding(.horizontal)
//      .scrollDisabled(viewModel.searchIsPresented)
      .scrollIndicators(.hidden)
      .onChange(of: viewModel.searchIsPresented) { _, newValue in
        withAnimation { proxy.scrollTo(newValue ? ScrollID.searchBar : ScrollID.top, anchor: .top) }
      }
    }
    .background(Color.backgroundWhite)
  }
  
  // MARK: 상단, ScrollViewReader의 사용을 위해 id 활용
  private var headView: some View {
    VStack(alignment: .leading) {
//      Image("logo")
//        .resizable()
//        .frame(width: 37, height: 21)
//        .opacity(viewModel.searchIsPresented ? 0 : 1)
//        .id(ScrollID.top)
//      MainView().logo
//        .padding([.leading, .vertical], 10)
      SearchBar(text: $viewModel.searchText, isEditing: $viewModel.searchIsPresented)
        .id(ScrollID.searchBar)
    }
    .padding(.top)
  }
  
//  private var artistView: some View {
//    LazyVStack(alignment: .leading) {
//      domesticArtistView
//        .padding(.vertical, 64)
//      foreignArtistView
//    }
//    .disabled(viewModel.searchIsPresented)
//    .opacity(viewModel.searchIsPresented ? 0 : 1)
//    .overlay { searchingHistoryView }
//  }
  
//  private var domesticArtistView: some View {
//    VStack(alignment: .leading) {
//      Text("국내 아티스트").bold()
//        .foregroundStyle(Color.mainBlack)
//      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
//        ForEach(tempColor, id: \.self) { item in
//          SearchArtistCell(tempColor: item, artistName: "Dummy")
//        }
//      }
//    }
//  }
//  
//  private var foreignArtistView: some View {
//    VStack(alignment: .leading) {
//      Text("해외 아티스트").bold()
//        .foregroundStyle(Color.mainBlack)
//      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
//        ForEach(tempColor, id: \.self) { item in
//          SearchArtistCell(tempColor: item, artistName: "Dummy")
//        }
//      }
//    }
//  }
//  
  private var searchingHistoryView: some View {
    VStack {
      if viewModel.searchText.isEmpty {
        HStack {
          Text("최근 검색")
            .bold()
            .foregroundStyle(Color.mainBlack)
          Spacer()
          Button("모두 지우기") {
            dataManager.deleteSearchHistoryAll()
          }
          .foregroundStyle(Color.mainOrange)
          .bold()
        }
        
        ForEach(history, id: \.self) { item in
          SearchHistoryCell(searchText: $viewModel.searchText, selectedTab: $selectedTab, history: item, dataManager: dataManager)
        }
      } else {
        SearchArtistList(selectedTab: $selectedTab, viewModel: viewModel)
      }
    }
    .onAppear { dataManager.modelContext = modelContext }
    .opacity(viewModel.searchIsPresented ? 1 : 0)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
}
