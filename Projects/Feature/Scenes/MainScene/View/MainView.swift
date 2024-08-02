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

struct MainView: View {
    @Binding var selectedTab: Tab
    @Query(sort: \LikeArtist.orderIndex, order: .reverse) var likeArtists: [LikeArtist]
    @AppStorage("hasClickedSeeArchiveArtistButton") private var hasClickedButton: Bool = false
    @StateObject var viewModel = MainViewModel()
    @Environment(\.modelContext) var modelContext
    @StateObject var tabViewManager: TabViewManager
    @State private var rect: CGRect = .zero
    
    public var body: some View {
        NavigationStack(path: $tabViewManager.pageStack) {
            Group {
                if likeArtists.isEmpty {
                    EmptyMainView(selectedTab: $selectedTab)
                } else {
                    contentView
                        .id(likeArtists)
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
    
    private var contentView: some View {
        ScrollView(.vertical) {
            seeArchiveArtistButton
                .padding(.top)
                .padding(.trailing, 36)
            artistContent
                .scrollIndicators(.hidden)
                .onReceive(tabViewManager.$scrollToTop) { _ in
                    viewModel.resetScroll()
                }
        }
    }
    
    private var seeArchiveArtistButton: some View {
        HStack {
            Spacer()
            NavigationLink(destination: ArchivingArtistView()) {
                Text("찜한 아티스트")
                    .foregroundColor(.gray)
                    .font(.footnote).bold()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                hasClickedButton = true
            }
        }
    }
    
    private var artistIndicators: some View {
        HStack {
            let count = likeArtists.count
            if count == 1 {
                Circle()
                    .frame(width: 8)
                    .foregroundColor(.black)
            } else {
                ForEach(0..<min(count, 5), id: \.self) { index in
                    indicator(for: index)
                }
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
    
    private var artistContent: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Spacer().frame(height: 10)
                artistIndicators
                artistNameScrollView
                artistImage
                artistItemsTabView()
            }
            .onChange(of: viewModel.scrollToIndex) {
                viewModel.selectedIndex = $0
            }
            if !hasClickedButton {
                MainTooltipView()
                    .padding(.trailing, 16)
            }
        }
    }
    
    public var artistNameScrollView: some View {
        TabView(selection: $viewModel.selectedIndex) {
            ForEach(Array(likeArtists.enumerated().prefix(5)), id: \.offset) { index, data in
                ArtistNameView(selectedTab: $selectedTab,
                               viewModel: viewModel,
                               index: index, name: data.artistInfo.name)
                    .id(index)
                    .lineLimit(nil)
            }
        }
        .frame(width: UIWidth, height: UIHeight * 0.1)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
          viewModel.selectedIndex = 0
          viewModel.scrollToIndex = 0
        }
        .onChange(of: viewModel.selectedIndex) { _, newIndex in
            viewModel.selectArtist(index: newIndex)
        }
    }
    
    private var artistImage: some View {
        ScrollView(.horizontal) {
            ScrollViewReader { scrollViewProxy in
                HStack(spacing: 12) {
                    ForEach(Array(likeArtists.enumerated().prefix(5)), id: \.offset) { index, data in
                        ArtistImage(selectedTab: $selectedTab, imageUrl: data.artistInfo.imageUrl)
                            .id(index)
                            .buttonStyle(BasicButtonStyle())
                    }
                }
                .scrollTargetLayout()
                .onAppear { viewModel.scrollToSelectedIndex(proxy: scrollViewProxy) }
                .onChange(of: viewModel.scrollToIndex) { _, _ in
                    viewModel.scrollToSelectedIndex(proxy: scrollViewProxy)
                }
                .onChange(of: likeArtists) { _, _ in
                    viewModel.resetScrollToIndex(proxy: scrollViewProxy, likeArtists: likeArtists)
                }
            }
        }
        .disabled(true)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .safeAreaPadding(.horizontal, UIWidth * 0.09)
        .safeAreaPadding(.trailing, UIWidth * 0.005)
    }
    
    @ViewBuilder
    func artistItemsTabView() -> some View {
        TabView(selection: $viewModel.selectedIndex) {
            ForEach(Array(likeArtists.enumerated().prefix(5)), id: \.offset) { index, data in
                ArtistsContentView(selectedTab: $selectedTab, viewModel: viewModel, artistInfo: data.artistInfo, tabViewManager: tabViewManager, index: index)
                    .tag(index)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewRectKey.self, value: [$0.frame(in: .local)])
                    })
                    .offset(y: 0)
            }
        }
        .frame(width: UIWidth * 0.95, height: rect.size.height + 30)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: viewModel.selectedIndex) { _, newIndex in
            viewModel.scrollToIndex = newIndex
        }
        .onPreferenceChange(ViewRectKey.self) { value in
            if let firstRect = value.first {
                self.rect = firstRect
            }
        }
    }
    
    private struct ViewRectKey: PreferenceKey {
        typealias Value = Array<CGRect>
        static var defaultValue = [CGRect]()
        static func reduce(value: inout Value, nextValue: () -> Value) {
            value += nextValue()
        }
    }
}
