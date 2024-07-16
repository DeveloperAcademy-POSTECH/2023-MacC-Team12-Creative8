//
//  MainView.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import Foundation
import SwiftUI
import SwiftData
import Core
import UI
import Combine

public struct MainView: View {
  @Binding var selectedTab: Tab
  @Query(sort: \LikeArtist.orderIndex, order: .reverse) var likeArtists: [LikeArtist]
  @StateObject var viewModel = MainViewModel()
  @Environment(\.modelContext) var modelContext
  @StateObject var tabViewManager: TabViewManager
  
  public var body: some View {
    NavigationStack(path: $tabViewManager.pageStack) {
      Group {
        if likeArtists.isEmpty {
          EmptyMainView(selectedTab: $selectedTab)
        } else {
          content
        }
      }
      .background(Color.backgroundGrey)
      .onAppear {
        viewModel.fetchInitialSetlists(likeArtists: likeArtists, modelContext: modelContext)
      }
      .onChange(of: likeArtists) { _, newValue in
        viewModel.updateSetlists(likeArtists: newValue)
      }
      .navigationDestination(for: NavigationDelivery.self, destination: viewModel.navigationDestination(for:))
    }
  }
  
  private var content: some View {
    ScrollView {
      VStack {
        seeAllButton
          .padding(.trailing, 36)
        Spacer().frame(height: 10)
        artistIndicators
        artistNameScrollView
        Spacer().frame(height: 16)
        artistContentView
      }
      .scrollIndicators(.hidden)
      .onReceive(tabViewManager.$scrollToTop) { _ in
        viewModel.resetScroll()
      }
      .onChange(of: viewModel.scrollToIndex) { _, newValue in
        viewModel.selectedIndex = newValue
      }
    }
  }
  
  private var seeAllButton: some View {
    HStack {
      Spacer()
      Text("모두 보기")
        .foregroundColor(.gray)
        .font(.subheadline).bold()
        .onTapGesture {
          selectedTab = .archiving
        }
    }
  }
  
  private var artistIndicators: some View {
    HStack {
      if likeArtists.count == 1 {
        Circle()
          .frame(width: 8)
          .foregroundColor(.black)
      } else {
        ForEach(0..<likeArtists.count, id: \.self, content: indicator)
      }
    }
  }
  
  @ViewBuilder
  private func indicator(for idx: Int) -> some View {
    if viewModel.selectedIndex == idx {
      Capsule()
        .frame(width: 16, height: 8)
        .foregroundColor(.black)
    } else {
      Circle()
        .frame(width: 8)
        .foregroundColor(.secondary.opacity(0.5))
    }
  }
  
  public var artistNameScrollView: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      ScrollViewReader { scrollViewProxy in
        HStack(alignment: .center) {
          ForEach(Array(likeArtists.enumerated()), id: \.offset) { index, data in
            ArtistNameView(selectedTab: $selectedTab,
                           viewModel: viewModel,
                           index: index, name: data.artistInfo.name)
            .id(index)
            .frame(width: UIWidth)
            .onTapGesture { viewModel.selectArtist(index: index) }
          }
        }
        .frame(height: UIWidth * 0.22)
        .onAppear { viewModel.scrollToSelectedIndex(proxy: scrollViewProxy) }
        .onChange(of: viewModel.scrollToIndex) { _, _ in viewModel.scrollToSelectedIndex(proxy: scrollViewProxy) }
        .onChange(of: likeArtists) { _, _ in viewModel.resetScrollToIndex(proxy: scrollViewProxy, likeArtists: likeArtists) }
      }
    }
  }
  
  public var artistContentView: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 12) {
        ForEach(Array(likeArtists.enumerated().prefix(5)), id: \.offset) { index, data in
          ArtistsContentView(selectedTab: $selectedTab, viewModel: viewModel, artistInfo: data.artistInfo, index: index)
        }
      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.viewAligned)
    .scrollIndicators(.hidden)
    .scrollPosition(id: $viewModel.scrollToIndex)
    .safeAreaPadding(.horizontal, UIWidth * 0.09)
    .safeAreaPadding(.trailing, UIWidth * 0.005)
  }
}
