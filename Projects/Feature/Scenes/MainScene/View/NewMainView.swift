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
      artistsContent
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .scrollPosition(id: $viewModel.scrollToIndex)
    }
    .onAppear {
      dataManager.modelContext = modelContext
    }
    .onChange(of: viewModel.scrollToIndex) {
      viewModel.selectedIndex = viewModel.scrollToIndex
    }
  }
  
  private var artistsNameScroll: some View {
    ScrollView(.horizontal) {
      ScrollViewReader { proxy in
        HStack(spacing: 0) {
          ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { index in
              ArtistNameView(selectedTab: $selectedTab)
              .foregroundColor(viewModel.selectedIndex == index ? Color.mainBlack : Color.fontGrey3)
              .frame(minHeight: UIWidth * 0.22)
              .background(.red)
              .id(index)
          }
          .safeAreaPadding(.horizontal, 36)
          
          Color.clear
            .frame(width: UIWidth * 0.7)
        }
        .onAppear {
          if viewModel.selectedIndex == nil || viewModel.scrollToIndex == nil {
            if !likeArtists.isEmpty {
              viewModel.selectedIndex = 0
              viewModel.scrollToIndex = 0
            }
          }
        }
        .onChange(of: viewModel.scrollToIndex) {
          viewModel.selectedIndex = viewModel.scrollToIndex
          withAnimation(.easeInOut(duration: 0.3)) {
            proxy.scrollTo(viewModel.scrollToIndex, anchor: .leading)
          }
        }
        .onChange(of: likeArtists, { _, _ in
          viewModel.selectedIndex = 0
          viewModel.scrollToIndex = 0
        })
        .scrollTargetLayout()
      }
    }
    .scrollIndicators(.hidden)
  }
  
  private var artistsContent: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 12) {
        ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { index in
          ArtistsContentView(selectedTab: $selectedTab)
            .id(index)
            .frame(width: UIWidth * 0.78)
        }
      }
      .scrollTargetLayout()
    }
    .safeAreaPadding(.horizontal, 36)
    .scrollPosition(id: $viewModel.scrollToIndex)
    .scrollIndicators(.hidden)
  }
}

#Preview {
  NewMainView(selectedTab: .constant(.home))
}
