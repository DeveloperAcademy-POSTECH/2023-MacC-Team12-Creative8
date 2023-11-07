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

public struct MainView: View {
  @Binding var selectedTab: Tab
  @Environment(\.colorScheme) var colorScheme
  
  @Query(sort: \LikeArtist.orderIndex, order: .reverse) var likeArtists: [LikeArtist]

  @StateObject var viewModel = MainViewModel()
  @State var dataManager = SwiftDataManager()
  
  @Environment(\.modelContext) var modelContext
  
  public var body: some View {
    GeometryReader { geometry in
      ScrollView {
        VStack {
          HStack { logo }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 25)
            .padding(.top, 23)
            .overlay {
              HStack { toolbarButton }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                .padding(.horizontal, 25)
            }

          Divider()
            .padding(.leading, 25)
            .padding(.vertical)
            .padding(.top, 3)
            .foregroundStyle(Color.lineGrey1)
          if likeArtists.isEmpty {
            EmptyMainView(selectedTab: $selectedTab)
              .frame(width: geometry.size.width)
              .frame(minHeight: geometry.size.height * 0.9)
          } else {
            mainArtistsView
          }
        }
        .padding(.vertical)
      }
      .scrollIndicators(.hidden)
      .id(likeArtists)
      .background(Color.backgroundWhite)
    }
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
  public var logo: some View {
    HStack(spacing: 0) {
      Rectangle()
        .frame(width: 19, height: 20)
        .cornerRadius(50, corners: .bottomRight)
        .cornerRadius(50, corners: .bottomLeft)
      Rectangle()
        .frame(width: 18, height: 20)
        .cornerRadius(50, corners: .topRight)
        .cornerRadius(50, corners: .topLeft)
    }
    .foregroundColor(Color.mainBlack)
  }
  public var toolbarButton: some View {
    ZStack(alignment: .trailingFirstTextBaseline) {
      Button {
        viewModel.isTapped.toggle()
      } label: {
        if colorScheme == .dark {
          Image(systemName: "sun.max.fill")
            .font(.subheadline)
        } else {
          Image(systemName: "moon.fill")
            .font(.subheadline)
        }
      }
      .foregroundColor(Color.mainBlack)
      .opacity(viewModel.isTapped ? 0 : 1)
//      .padding(6)
      if viewModel.isTapped {
        ToolbarDarkModeButtons(viewModel: viewModel)
      }
    }
  }
  public var mainArtistsView: some View {
    VStack(spacing: 0) {
      artistNameScrollView
        .padding(.bottom)
      artistContentView
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .scrollPosition(id: $viewModel.scrollToIndex)
        .safeAreaPadding(.horizontal, UIWidth * 0.11)
      Spacer()
    }
    .onChange(of: viewModel.scrollToIndex) {
      viewModel.selectedIndex = viewModel.scrollToIndex
    }
    .onAppear {
      if viewModel.selectedIndex == nil || viewModel.scrollToIndex == nil {
        if !likeArtists.isEmpty {
          viewModel.selectedIndex = 0
          viewModel.scrollToIndex = 0
        }
      }
    }
  }
  public var artistNameScrollView: some View {
    ScrollView(.horizontal) {
      ScrollViewReader { scrollViewProxy in
        HStack(spacing: UIWidth * 0.13) {
          ForEach(0..<likeArtists.prefix(5).count, id: \.self) { data in
            let artistName = viewModel.replaceFirstSpaceWithNewline(likeArtists[data].artistInfo.name)
            Text(.init(artistName))
              .background(Color.clear)
              .font(.system(size: 25))
              .bold()
              .id(data)
              .foregroundColor(viewModel.selectedIndex == data ? Color.mainBlack : Color.fontGrey3)
              .animation(.easeInOut(duration: 0.2))
              .onTapGesture {
                withAnimation {
                  viewModel.selectedIndex = data
                  viewModel.scrollToIndex = data
                }
              }
          }
          Color.clear
            .frame(width: UIWidth * 0.7)
        }
        .onChange(of: viewModel.scrollToIndex) {
          viewModel.selectedIndex = viewModel.scrollToIndex
          withAnimation(.easeInOut(duration: 0.3)) {
            scrollViewProxy.scrollTo(viewModel.scrollToIndex, anchor: .leading)
          }
        }
        .scrollTargetLayout()
      }
    }
    .frame(minWidth: UIWidth * 0.16)
    .scrollIndicators(.hidden)
    .safeAreaPadding(.leading, UIWidth * 0.12)
  }
  public var artistContentView: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 18) {
        ForEach(0 ..< likeArtists.prefix(5).count, id: \.self) { data in
          VStack(spacing: 0) {
            if data < likeArtists.count { // 아카이빙 뷰에서 지울 때마다 인덱스 에러 나서 이렇게 했습니다 ㅠ.ㅠ
              NavigationLink(destination: ArtistView(selectedTab: $selectedTab, artistName: likeArtists[data].artistInfo.name, artistAlias: likeArtists[data].artistInfo.alias, artistMbid: likeArtists[data].artistInfo.mbid)) {
                if likeArtists[data].artistInfo.imageUrl.isEmpty {
                  artistEmptyImage
                } else {
                  let imageUrl = likeArtists[data].artistInfo.imageUrl
                  ArtistImage(selectedTab: $selectedTab, imageUrl: imageUrl)
                }
              }
              HStack {
                Text("\(likeArtists[data].artistInfo.name)의 최근 공연")
                  .font(.caption)
                  .foregroundStyle(Color.fontGrey2)
                Spacer()
              }
              .padding([.horizontal, .top])
              if viewModel.isLoading {
                VStack {
                  Spacer()
                  ProgressView()
                    .frame(width: UIWidth * 0.5, height: UIHeight * 0.2)
                  Spacer()
                }
              } else {
                let current: [Setlist?] = viewModel.setlists[data] ?? []
                  ForEach(Array(current.prefix(3).enumerated()), id: \.element?.id) { index, item in
                    let dateAndMonth = viewModel.getFormattedDateAndMonth(date: item?.eventDate ?? "")
                    let year = viewModel.getFormattedYear(date: item?.eventDate ?? "")
                    let city = item?.venue?.city?.name ?? ""
                    let country = item?.venue?.city?.country?.name ?? ""
                    let firstSong = item?.sets?.setsSet?.first?.song?.first?.name ?? "세트리스트 정보가 아직 없습니다"
                    let setlistId = item?.id ?? ""
                    if data < likeArtists.count {
                      let artistInfo = ArtistInfo(
                        name: likeArtists[data].artistInfo.name,
                        alias: likeArtists[data].artistInfo.alias,
                        mbid: likeArtists[data].artistInfo.mbid,
                        gid: likeArtists[data].artistInfo.gid,
                        imageUrl: likeArtists[data].artistInfo.imageUrl,
                        songList: likeArtists[data].artistInfo.songList)
                      VStack(spacing: 0) {
                        if data < likeArtists.count {
                          ArtistSetlistCell(dateAndMonth: dateAndMonth ?? "", year: year ?? "", city: city, country: country, firstSong: firstSong, setlistId: setlistId, artistInfo: artistInfo)
                        }
                        if let lastIndex = current.prefix(3).lastIndex(where: { $0 != nil }), index != lastIndex {
                          Divider()
                            .foregroundStyle(Color.lineGrey1)
                        }
                      }
                      .opacity(viewModel.selectedIndex == data ? 1.0 : 0)
                      .animation(.easeInOut(duration: 0.1))
                      .frame(width: UIWidth * 0.78)
                    }
                  }
                
                if current.isEmpty {
                  EmptyMainSetlistView()
                }
              }
              Spacer()
            }
          }
        }
      }
      .scrollTargetLayout()
    }
  }
  public var artistEmptyImage: some View {
    RoundedRectangle(cornerRadius: 15)
        .foregroundStyle(Color.mainGrey1)
        .overlay(
          Image("ticket", bundle: setaBundle)
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(Color.lineGrey1)
            .aspectRatio(contentMode: .fit)
            .frame(width: UIWidth * 0.43)
        )
        .overlay {
          artistImageOverlayButton
        }
        .frame(width: UIWidth * 0.78, height: UIWidth * 0.78)
  }

  public var artistImageOverlayButton: some View {
      VStack {
        Spacer()
        HStack {
          Spacer()
          Circle()
            .frame(width: UIWidth * 0.15)
            .foregroundStyle(Color.mainBlack)
            .overlay {
              Image(systemName: "arrow.right")
                .foregroundStyle(Color.settingTextBoxWhite)
            }
        }
      }
      .padding([.trailing, .bottom])
    }
  }

// 로고 만들기
extension View {
  func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
    clipShape( RoundedCorner(radius: radius, corners: corners) )
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
