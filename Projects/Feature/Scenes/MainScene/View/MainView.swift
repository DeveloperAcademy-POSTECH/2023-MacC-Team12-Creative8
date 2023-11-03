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
  @AppStorage("appearance")
  var appearnace: ButtonType = .automatic
  
  @Environment(\.colorScheme) var colorScheme
  
  @Query(sort: \LikeArtist.orderIndex) var likeArtists: [LikeArtist]
  
  @StateObject var viewModel = MainViewModel()
  @State var dataManager = SwiftDataManager()
  
  @Environment(\.modelContext) var modelContext
  
  public init() {
  }
  public var body: some View {
    GeometryReader { geometry in
      ScrollView { // 스크롤
        VStack(spacing: 0) {
          Divider()
            .padding(.leading, 24)
            .padding(.vertical)
            .foregroundStyle(Color.lineGrey1)
          if likeArtists.isEmpty {
            EmptyMainView()
              .frame(width: geometry.size.width)
              .frame(minHeight: geometry.size.height * 0.9)
          } else {
            mainArtistsView
          }
        }
      } // 스크롤
      .scrollIndicators(.hidden)
      .id(likeArtists)
      .background(Color.backgroundWhite)
    }
    .navigationTitle("")
    .onAppear {
      dataManager.modelContext = modelContext
      var idx = 0
      for artist in likeArtists {
        viewModel.getSetlistsFromSetlistFM(artistMbid: artist.artistInfo.mbid, idx: idx)
        idx += 1
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        logo
      }
      ToolbarItem(placement: .topBarTrailing) {
        ZStack(alignment: .trailingFirstTextBaseline) {
          Button {
            // 다크모드 기능 넣기
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
          .padding(6)
          //              .overlay {
          if viewModel.isTapped {
            darkmodeButtons
          }
          //              }
        }
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
  public var darkmodeButtons: some View {
    ZStack(alignment: .center) {
      RoundedRectangle(cornerRadius: 36)
        .foregroundStyle(Color.mainGrey1)
        .frame(width: UIWidth * 0.45, height: UIWidth * 0.09)
        .padding(.bottom)
      VStack {
        HStack(spacing: UIWidth * 0.07) {
          ForEach(ButtonType.allCases) { mode in
            TopButtonView(buttonType: mode, viewModel: viewModel)
              .tag(mode)
              .foregroundStyle(mode == appearnace ?  Color.mainBlack: Color.fontGrey3)
          }
        }
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
            .frame(width: UIWidth * 0.6)
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
              NavigationLink(destination: ArtistView(artistName: likeArtists[data].artistInfo.name, artistAlias: likeArtists[data].artistInfo.alias, artistMbid: likeArtists[data].artistInfo.mbid)) {
                if likeArtists[data].artistInfo.imageUrl.isEmpty {
                  artistEmptyImage
                } else {
                  AsyncImage(url: URL(string: likeArtists[data].artistInfo.imageUrl)) { image in
                    image
                      .resizable()
                      .scaledToFill()
                      .frame(width: UIWidth * 0.78, height: UIWidth * 0.78)
                      .overlay {
                        artistImageOverlayButton
                      }
                      .clipShape(RoundedRectangle(cornerRadius: 15))
                          .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.mainGrey1, lineWidth: 1))
                  } placeholder: {
                    ProgressView()
                  }
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
                    let firstSong = item?.sets?.setsSet?.first?.song?.first?.name ?? "세트리스트 정보가 아직 없습니다."
                    VStack(spacing: 0) {
                      NavigationLink {
                        let artistInfo = ArtistInfo(
                          name: likeArtists[data].artistInfo.name,
                          alias: likeArtists[data].artistInfo.alias,
                          mbid: likeArtists[data].artistInfo.mbid,
                          gid: likeArtists[data].artistInfo.gid,
                          imageUrl: likeArtists[data].artistInfo.imageUrl,
                          songList: likeArtists[data].artistInfo.songList)
                        SetlistView(setlistId: item?.id ?? "", artistInfo: artistInfo)
                      } label: {
                        HStack(spacing: 0) {
                          VStack(alignment: .center, spacing: 0) {
                            Text(year ?? "")
                              .foregroundStyle(Color.fontGrey25)
                              .padding(.bottom, 2)
                            Text(dateAndMonth ?? "")
                              .foregroundStyle(Color.mainBlack)
                              .kerning(-0.5)
                          }
                          .font(.headline)
                          Spacer()
                            .frame(width: UIWidth * 0.08)
                          VStack(alignment: .leading, spacing: 0) {
                            Text(city + ", " + country)
                              .font(.subheadline)
                              .foregroundStyle(Color.mainBlack)
                              .lineLimit(1)
                              .padding(.bottom, 3)
                            Text(firstSong)
                              .font(.footnote)
                              .lineLimit(1)
                              .foregroundStyle(Color.fontGrey25)
                          }
                          .foregroundStyle(Color.fontBlack)
                          .font(.system(size: 14))
                          Spacer()
                        }
                        .padding()
                      }
                      //                  } // 내비
                      if let lastIndex = current.prefix(3).lastIndex(where: { $0 != nil }), index != lastIndex {
                        Divider()
                          .foregroundStyle(Color.lineGrey1)
                      }
                    }
                    .opacity(viewModel.selectedIndex == data ? 1.0 : 0)
                    .animation(.easeInOut(duration: 0.1))
                    .frame(width: UIWidth * 0.78)
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
          Image("mainViewTicket")
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(Color.lineGrey1)
            .aspectRatio(contentMode: .fit)
            .frame(width: UIWidth * 0.43)
            .overlay {
              artistImageOverlayButton
            }
        )
        .frame(width: UIWidth * 0.78, height: UIWidth * 0.78)
  }
  public var artistImageOverlayButton: some View {
    ZStack {
      Color.black
        .opacity(0.2)
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
            .shadow(color: .white.opacity(0.25), radius: 10, x: 0, y: 4)
        }
      }
      .padding([.trailing, .bottom])
    }
  }
}
struct EmptyMainView: View {
  var body: some View {
    VStack {
      Spacer()
      Text("찜한 아티스트가 없습니다")
        .font(.callout)
        .padding(.bottom)
        .foregroundStyle(Color.mainBlack)
      Text("관심있는 아티스트 정보를 빠르게\n확인하고 싶으시다면 찜을 해주세요")
        .font(.footnote)
        .multilineTextAlignment(.center)
        .foregroundStyle(Color.fontGrey2)
        .padding(.bottom)
      NavigationLink(destination: SearchView()) {
        Text("아티스트 찜하러 가기 →")
          .foregroundStyle(Color.mainWhite)
          .font(.system(size: 14))
          .padding(EdgeInsets(top: 17, leading: 23, bottom: 17, trailing: 23))
          .background(RoundedRectangle(cornerRadius: 14)
            .foregroundStyle(Color.buttonBlack))
          .bold()
      }
      .padding(.vertical)
      Spacer()
    }
  }
}
struct TopButtonView: View {
  var buttonType: ButtonType
  var viewModel: MainViewModel
  @AppStorage("appearance")
  var appearnace: ButtonType = .automatic
  @Environment(\.colorScheme) var colorScheme
  var body: some View {
    Button {
      viewModel.isTapped.toggle()
      appearnace = buttonType
    } label: {
      VStack {
        Image(systemName: buttonType.icon)
          .foregroundStyle(buttonType == appearnace ? Color.mainBlack : Color.fontGrey3)
          .font(.subheadline)
          .padding(6)
        Text(buttonType.name)
          .font(.system(size: 10))
          .foregroundStyle(buttonType == appearnace ? Color.mainBlack : Color.fontGrey2)
      }
    }.tag(buttonType)
  }
}
struct EmptyMainSetlistView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Spacer()
      Text("세트리스트 정보가 없습니다.")
        .font(.system(size: 16))
        .fontWeight(.semibold)
        .foregroundStyle(Color.mainBlack)
        .padding(.horizontal)
      Group {
        Text("찜한 가수의 세트리스트가 없다면,\n")
        +
        Text("Setlist.fm")
          .underline()
        +
        Text("에서 직접 추가할 수 있어요.")
      }
      .foregroundStyle(Color.fontGrey2)
      .font(.footnote)
      .padding()
      Link(destination: URL(string: "https://www.setlist.fm")!) {
        RoundedRectangle(cornerRadius: 14)
          .foregroundStyle(Color.mainGrey1)
          .frame(height: UIHeight * 0.06)
          .overlay {
            Text("Setlist.fm 바로가기")
              .foregroundStyle(Color.mainBlack)
              .bold()
          }
          .padding(.top)
      }
      Spacer()
    }
    .frame(width: UIWidth * 0.78)
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
  MainView()
}
