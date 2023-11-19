//
//  NewMainView.swift
//  Feature
//
//  Created by 장수민 on 11/17/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData
import Core
import UI
import Combine

public struct NewMainView: View {
  @Binding var selectedTab: Tab
  @Query(sort: \LikeArtist.orderIndex, order: .reverse) var likeArtists: [LikeArtist]
  @StateObject var viewModel = NewMainViewModel()
  @State var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  
  public var body: some View {
    VStack(spacing: 0) {
      artistsNameScroll
        .padding(.top, 33)
      artistContent
      Spacer()
    }
    .onAppear {
      dataManager.modelContext = modelContext
    }
    .onAppear {
//      if viewModel.selectedIndex == nil || viewModel.scrollToIndex == nil {
//        if !likeArtists.isEmpty {
//          viewModel.selectedIndex = 0
//          viewModel.scrollToIndex = 0
//        }
//      }
      viewModel.selectedIndex = 0
      viewModel.scrollToIndex = viewModel.selectedIndex
    }
    .onChange(of: viewModel.scrollToIndex) {
      viewModel.selectedIndex = viewModel.scrollToIndex
    }
    .onChange(of: likeArtists, { _, _ in
      viewModel.selectedIndex = 0
      viewModel.scrollToIndex = viewModel.selectedIndex
    })
    .background(Color.mainWhite)
  }
  
  private var artistsNameScroll: some View {
    ScrollView(.horizontal) {
      ScrollViewReader { proxy in
        HStack(spacing: UIWidth * 0.13) {
          ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { index in
            ArtistNameView(selectedTab: $selectedTab, 
                           viewModel: viewModel,
                           index: index)
          }
          Color.clear
            .frame(width: UIWidth * 0.3)
        }
        .onChange(of: viewModel.scrollToIndex) {
          viewModel.selectedIndex = viewModel.scrollToIndex
          withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(viewModel.scrollToIndex, anchor: .leading)
          }
        }
      }
    }
    .frame(maxHeight: UIWidth * 0.22)
    .scrollIndicators(.hidden)
    .safeAreaPadding(.horizontal, 36)
  }
  private var artistContent: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 12) {
        ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { index in
          ArtistsContentView(selectedTab: $selectedTab, 
                             viewModel: viewModel,
                             index: index)
        }
      }
      .scrollTargetLayout()
    }
    .scrollPosition(id: $viewModel.scrollToIndex)
    .scrollTargetBehavior(.viewAligned)
    .scrollIndicators(.hidden)
    .safeAreaPadding(.horizontal, 36)
  }
}

#Preview {
  NewMainView(selectedTab: .constant(.home))
}
