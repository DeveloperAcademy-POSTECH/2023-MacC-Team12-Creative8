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
  
  let screenWidth = UIScreen.main.bounds.size.width
  let screenHeight = UIScreen.main.bounds.size.height
  
  @Query var likeArtists: [LikeArtist]
  
  @ObservedObject var viewModel = MainViewModel()
  @State var dataManager = SwiftDataManager()
  @ObservedObject var setlistViewModel = ArtistViewModel()
  
  @Environment(\.modelContext) var modelContext
  
  public init() {
  }
  
  public var body: some View {
    GeometryReader { geometry in
      ScrollView { // 스크롤
        VStack(spacing: 0) {
//          VStack(spacing: 0) {
            //            HStack {
            //              logo
            //              Spacer()
            //              ZStack(alignment: .trailingFirstTextBaseline) {
            //                Button {
            //                  // 다크모드 기능 넣기
            //                  viewModel.isTapped.toggle()
            //                } label: {
            //                  if colorScheme == .dark {
            //                    Image(systemName: "sun.max.fill")
            //                      .font(.title3)
            //                  } else {
            //                    Image(systemName: "moon.fill")
            //                      .font(.title3)
            //                  }
            //                }
            //                .foregroundColor(Color.mainBlack)
            //                .opacity(viewModel.isTapped ? 0 : 1)
            //                .padding(6)
            //                .overlay {
            //                  if viewModel.isTapped {
            //                    darkmodeButtons
            //                      .offset(x: -(screenWidth * 0.16))
            //                  }
            //                }
            //              }
            //            }
            //            .padding(.horizontal, 24)
//          }
//          .padding(.vertical)
          Divider()
            .padding(.leading, 24)
            .padding(.bottom)
            .foregroundStyle(Color.lineGrey1)
          if likeArtists.isEmpty {
            EmptyMainView()
              .frame(width: geometry.size.width)
              .frame(minHeight: geometry.size.height * 0.75)
          } else {
            mainArtistsView
          }
        }
      } // 스크롤
      .scrollIndicators(.hidden)
    }
    .onAppear {
      dataManager.modelContext = modelContext
      var idx = 0
      for artist in likeArtists {
        viewModel.getSetlistsFromSetlistFM(artistMbid: artist.artistInfo.mbid, idx: idx)
        idx += 1
      }
    }
        .toolbar(content: {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                logo
            }
        })
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
  }
  public var darkmodeButtons: some View {
    ZStack(alignment: .top) {
      RoundedRectangle(cornerRadius: 36)
        .foregroundStyle(Color.mainGrey1)
        .frame(width: screenWidth * 0.45, height: screenWidth * 0.09)
      VStack {
        HStack(spacing: screenWidth * 0.07) {
          ForEach(ButtonType.allCases) { mode in
            TopButtonView(buttonType: mode, viewModel: viewModel)
              .tag(mode)
              .foregroundStyle(mode == appearnace ?  Color.fontBlack: Color.fontGrey3)
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
        .safeAreaPadding(.horizontal, screenWidth * 0.11)
      Spacer()
    }
    .onChange(of: viewModel.scrollToIndex) {
      viewModel.selectedIndex = viewModel.scrollToIndex
    }
    .onAppear {
      if likeArtists.count != 0 {
        viewModel.selectedIndex = 0
        viewModel.scrollToIndex = 0
      }
    }
  }
  public var artistNameScrollView: some View {
    ScrollView(.horizontal) {
      ScrollViewReader { scrollViewProxy in
        HStack(spacing: screenWidth * 0.13) {
          ForEach(0..<likeArtists.count, id: \.self) { data in
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
            .frame(width: screenWidth * 0.6)
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
    .frame(minWidth: screenWidth * 0.16)
    .scrollIndicators(.hidden)
    .safeAreaPadding(.leading, screenWidth * 0.12)
  }
  public var artistContentView: some View {
    ScrollView(.horizontal) {
      HStack(spacing: 18) {
        ForEach(0 ..< likeArtists.count, id: \.self) { data in
          VStack(spacing: 0) {
            NavigationLink(destination: ArtistView(artistName: likeArtists[data].artistInfo.name, artistAlias: likeArtists[data].artistInfo.alias, artistMbid: likeArtists[data].artistInfo.mbid)) {
              AsyncImage(url: URL(string: likeArtists[data].artistInfo.imageUrl)) { image in
                image
                  .resizable()
                  .scaledToFill()
                  .frame(width: screenWidth * 0.78, height: screenWidth * 0.78)
                  .overlay {
                    ZStack {
                      Color.black
                        .opacity(0.2)
                      VStack {
                        Spacer()
                        HStack {
                          Spacer()
                          Circle()
                            .frame(width: screenWidth * 0.15)
                            .foregroundStyle(Color.mainBlack)
                            .overlay {
                              Image(systemName: "arrow.right")
                                .foregroundStyle(Color.backgroundWhite)
                            }
                            .shadow(color: .white.opacity(0.25), radius: 10, x: 0, y: 4)
                        }
                      }
                      .padding([.trailing, .bottom])
                    }
                  }
                  .clipShape(RoundedRectangle(cornerRadius: 15))
              } placeholder: {
                ProgressView()
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
              ProgressView()
            } else {
              let current: [Setlist?] = viewModel.setlists[data] ?? []
              ForEach(current.prefix(3), id: \.?.id) { item in
                let dateAndMonth = viewModel.getFormattedDateAndMonth(date: item?.eventDate ?? "")
                let year = viewModel.getFormattedYear(date: item?.eventDate ?? "")
                let city = item?.venue?.city?.name ?? ""
                let country = item?.venue?.city?.country?.name ?? ""
                VStack(spacing: 0) {
//                  NavigationLink(destination: SetlistView(setlist: item, artistInfo: likeArtists[data].artistInfo)) { //
                    HStack(spacing: 0) {
                      VStack(alignment: .center, spacing: 0) {
                        Text(year ?? "")
                          .foregroundStyle(Color.fontGrey25)
                          .padding(.bottom, 2)
                        Text(dateAndMonth ?? "")
                          .foregroundStyle(Color.fontBlack)
                          .kerning(-0.5)
                      }
                      .font(.headline)
                      Spacer()
                        .frame(width: screenWidth * 0.08)
                      VStack(alignment: .leading, spacing: 0) {
                        Text(city + ", " + country)
                          .font(.subheadline)
                          .lineLimit(1)
                          .padding(.bottom, 3)
                        Text(item?.sets?.setsSet?.first?.name ?? "세트리스트 정보가 아직 없습니다.")
                          .font(.footnote)
                          .lineLimit(1)
                          .foregroundStyle(Color.fontGrey25)
                      }
                      .foregroundStyle(Color.fontBlack)
                      .font(.system(size: 14))
                      Spacer()
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
//                  } //
                  if item != current.prefix(3).last {
                    Divider()
                      .foregroundStyle(Color.lineGrey1)
                  }
//                    .opacity(isLastElement ? 0 : 1)
                }
                .opacity(viewModel.selectedIndex == data ? 1.0 : 0)
                .animation(.easeInOut(duration: 0.1))
                .frame(width: screenWidth * 0.78)
              }
            }
            Spacer()
          }
        }
      }
      .scrollTargetLayout()
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
        .foregroundStyle(Color.fontBlack)
      Text("관심있는 아티스트 정보를 빠르게\n확인하고 싶으시다면 찜을 해주세요")
        .font(.footnote)
        .multilineTextAlignment(.center)
        .foregroundStyle(
          Color.fontGrey2)
        .padding(.bottom)
      // TODO: 찜하기 화면 연결
      NavigationLink(destination: SearchView()) {
        Text("아티스트 찜하러 가기 →")
          .foregroundStyle(Color.fontWhite)
          .font(.system(size: 14))
          .padding(EdgeInsets(top: 17, leading: 8, bottom: 17, trailing: 8))
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
          .font(.title3)
          .padding(6)
        Text(buttonType.name)
          .font(.system(size: 10))
      }
    }.tag(buttonType)
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
