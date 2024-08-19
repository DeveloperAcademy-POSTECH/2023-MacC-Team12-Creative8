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
    @State private var isShowToolTip: Bool = true
    @StateObject var viewModel = MainViewModel()
    @Environment(\.modelContext) var modelContext
    @StateObject var tabViewManager: TabViewManager
    @State private var rect: CGRect = .zero
    @State private var buttonFrame: CGRect = .zero
    
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
            .background(Color.gray6)
            .onAppear {
                viewModel.fetchInitialSetlists(likeArtists: likeArtists, modelContext: modelContext)
                viewModel.selectedIndex = 0
            }
            .onChange(of: likeArtists) { _, newValue in
                viewModel.updateSetlists(likeArtists: newValue)
            }
        }
    }
    
    private var contentView: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical) {
                VStack {
                    likeArtistsButton
                    ZStack(alignment: .topTrailing) {
                        artistContentView()
                        if isShowToolTip {
                            MainTooltipView()
                                .safeAreaPadding(.trailing, UIWidth * 0.05)
                        }
                    }
                    Spacer(minLength: UIHeight * 0.1)
                }
            }
            VStack {
                Spacer()
                artistIndicators
                    .padding(.bottom, 8)
            }
        }
    }
    
    private var likeArtistsButton: some View {
        HStack {
            Spacer()
            NavigationLink(destination: ArchivingArtistView()) {
                Text("찜한 아티스트")
                    .font(.footnote).bold()
            }
        }
        .foregroundColor(Color.gray)
        .padding(.top)
        .safeAreaPadding(.trailing, UIWidth * 0.1)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                
                isShowToolTip = false
            }
        }
    }
    
    private var artistIndicators: some View {
        HStack(spacing: 8) {
            if likeArtists.count == 1 {
                Circle()
                    .frame(width: 6)
                    .foregroundColor(.mainBlack)
            } else {
                ForEach(0..<min(likeArtists.count, 5), id: \.self) { index in
                    indicator(for: index)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 76)
              .foregroundStyle(Color.gray600))
    }
    
    @ViewBuilder
    private func indicator(for idx: Int) -> some View {
        if viewModel.selectedIndex == idx {
            Capsule()
                .frame(width: 12, height: 6)
                .foregroundColor(.mainBlack)
        } else {
            Circle()
                .frame(width: 6)
                .foregroundColor(.mainBlack.opacity(0.3))
        }
    }
    
    @ViewBuilder
    func artistContentView() -> some View {
        TabView(selection: $viewModel.selectedIndex) {
            ForEach(Array(likeArtists.enumerated().prefix(5)), id: \.offset) { index, data in
                VStack {
					VStack {
						// 아티스트 이름
						ArtistNameView(isShowToolTip: $isShowToolTip,
									   selectedTab: $selectedTab,
									   viewModel: viewModel,
									   index: index,
									   name: data.artistInfo.name)
                        .lineLimit(nil)
                        
                        // 아티스트 이미지
                        NavigationLink(destination: ArtistView(selectedTab: $selectedTab,
                                                               artistName: data.artistInfo.name,
                                                               artistAlias: data.artistInfo.alias,
                                                               artistMbid: data.artistInfo.mbid)) {
                            ArtistImage(selectedTab: $selectedTab,
                                        imageUrl: data.artistInfo.imageUrl)
                            .buttonStyle(BasicButtonStyle())
                        }
                    }
                    .frame(height: UIHeight * 0.45)
                    // 아티스트 세트리스트
					NavigationLink {
						SetlistView(setlistId: viewModel.setlists[index]?.first??.id, artistInfo: ArtistInfo(
						  name: data.artistInfo.name,
						  alias: data.artistInfo.alias,
						  mbid: data.artistInfo.mbid,
						  gid: data.artistInfo.gid,
						  imageUrl: data.artistInfo.imageUrl,
						  songList: data.artistInfo.songList))
					} label: {
						ArtistsContentView(selectedTab: $selectedTab,
										   viewModel: viewModel,
										   artistInfo: data.artistInfo,
										   tabViewManager: tabViewManager,
										   index: index)
					}
                    .tag(index)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewRectKey.self, value: [$0.frame(in: .local)])
                    })
                    .offset(y: 0)
                    .frame(width: UIWidth * 0.95, height: rect.size.height + 30)
                    
                }
                .tag(index)
                
            }
        }
        .frame(width: UIWidth, height: rect.size.height + UIHeight * 0.45 + 30)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .padding(.top, 10)
        
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
