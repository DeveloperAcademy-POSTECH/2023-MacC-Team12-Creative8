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

public struct SearchView: View {
  @Query private var history: [SearchHistory] = []
  @StateObject var viewModel = SearchViewModel()
  @Environment (\.modelContext) var modelContext
//  @StateObject var dataManager = SearchHistoryManager()
  // MARK: - 임시 값
  let tempColor: [Color] = [.red, .orange, .green, .blue, .purple, .pink, .cyan, .indigo, .mint]
  
  public init() {}
  
  public var body: some View {
    ScrollViewReader { proxy in
      ScrollView {
        Group {
          headView
          artistView
        }
        .padding(.horizontal)
      }
      .scrollDisabled(viewModel.searchIsPresented)
      .onChange(of: viewModel.searchIsPresented) { _, newValue in
        withAnimation { proxy.scrollTo(newValue ? ScrollID.searchBar : ScrollID.top, anchor: .top) }
      }
    }
  }

  // MARK: 상단, ScrollViewReader의 사용을 위해 id 활용
  private var headView: some View {
    VStack(alignment: .leading) {
      Text("누구의 **세트리스트**를\n찾으시나요?")
      .font(.largeTitle)
      .opacity(viewModel.searchIsPresented ? 0 : 1)
      .id(ScrollID.top)
      .padding(.vertical)

      SearchBar(text: $viewModel.searchText, isEditing: $viewModel.searchIsPresented)
        .id(ScrollID.searchBar)
        .onChange(of: viewModel.searchText) {
          viewModel.getArtistList()
        }
    }
    .padding(.top)
  }

  private var artistView: some View {
    LazyVStack(alignment: .leading) {
      domesticArtistView
        .padding(.vertical, 64)
      foreignArtistView
    }
    .disabled(viewModel.searchIsPresented)
    .opacity(viewModel.searchIsPresented ? 0 : 1)
    .overlay { searchingHistoryView }
  }

  private var domesticArtistView: some View {
    VStack(alignment: .leading) {
      Text("국내 아티스트").bold()
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
        ForEach(tempColor, id: \.self) { item in
          SearchArtistCell(tempColor: item, artistName: "Dummy")
        }
      }
    }
  }

  private var foreignArtistView: some View {
    VStack(alignment: .leading) {
      Text("해외 아티스트").bold()
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
        ForEach(tempColor, id: \.self) { item in
          SearchArtistCell(tempColor: item, artistName: "Dummy")
        }
      }
    }
  }

  private var searchingHistoryView: some View {
    ScrollView {
      LazyVStack {
        if viewModel.searchText.isEmpty {
          HStack {
            Text("최근 검색").bold()
            Spacer()
            Button("Test") {
//              dataManager.addItem(searchText: "Dummy")
            }
            Button("모두 지우기") {
//              dataManager.deleteAll()
            }
            .foregroundStyle(.black)
            .bold()
          }

          ForEach(history, id: \.self) { item in
//            SearchHistoryCell(searchText: $viewModel.searchText, dataManager: dataManager, history: item)
          }
        } else {
          SearchArtistList(viewModel: viewModel)
        }
      }
    }
//    .onAppear { dataManager.modelContext = modelContext }
    .opacity(viewModel.searchIsPresented ? 1 : 0)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
}
