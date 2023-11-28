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
  @State var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  
  public var body: some View {
      Group {
        if likeArtists.isEmpty {
          EmptyMainView(selectedTab: $selectedTab)
        } else {
          ScrollView {
          mainArtistsView
            .padding(.top, 11)
            .id(likeArtists)
          }
          .scrollIndicators(.hidden)
        }
      }
    .padding(.vertical)
    .background(Color.backgroundWhite)
    .onAppear {
      dataManager.modelContext = modelContext
      var idx = 0
      if viewModel.setlists[0] == nil {
        for artist in likeArtists {
          viewModel.getSetlistsFromSetlistFM(artistMbid: artist.artistInfo.mbid, idx: idx)
          idx += 1
        }
      }
    }
    .onChange(of: likeArtists) { _, newValue in
      var idx = 0
      for artist in newValue {
        viewModel.getSetlistsFromSetlistFM(artistMbid: artist.artistInfo.mbid, idx: idx)
        idx += 1
      }
    }
  }
  public var mainArtistsView: some View {
    VStack(spacing: 0) {
      artistNameScrollView
      artistContentView
    }
    .onChange(of: viewModel.scrollToIndex) {
      viewModel.selectedIndex = viewModel.scrollToIndex
    }
  }
  public var artistNameScrollView: some View {
    ScrollView(.horizontal) {
      ScrollViewReader { scrollViewProxy in
        HStack(spacing: UIWidth * 0.12) {
          ForEach(Array(likeArtists.enumerated().prefix(5)), id: \.offset) { index, data in
            let artistName = viewModel.replaceFirstSpaceWithNewline(data.artistInfo.name)
            ArtistNameView(selectedTab: $selectedTab,
                           viewModel: viewModel,
                           index: index, name: artistName)
            .id(index)
            .onTapGesture {
              withAnimation {
                viewModel.selectedIndex = index
                viewModel.scrollToIndex = index
              }
            }
          }
          Color.clear
            .frame(width: UIWidth * 0.7)
        }
        .frame(height: UIWidth * 0.22)
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
            scrollViewProxy.scrollTo(viewModel.scrollToIndex, anchor: .leading)
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
    .safeAreaPadding(.leading, UIWidth * 0.09)
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
  }
}
extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape(RoundedCorner(radius: radius, corners: corners))
  }
}
struct RoundedCorner: Shape {
  var radius: CGFloat = .infinity
  var corners: UIRectCorner = .allCorners
  
  func path(in rect: CGRect) -> Path {
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    return Path(path.cgPath)
  }
}

#Preview {
  MainView(selectedTab: .constant(.home))
}
