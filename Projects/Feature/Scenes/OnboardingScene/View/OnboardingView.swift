//
//  OnboardingView.swift
//  Feature
//
//  Created by 예슬 on 2023/10/21.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI

public struct OnboardingView: View {
  @StateObject var onboardingViewModel = OnboardingViewModel()
  @StateObject var artistFetchService = ArtistFetchService()
  @StateObject var artistViewModel = ArtistViewModel()
  @Environment(\.modelContext) var modelContext
  @StateObject var dataManager = SwiftDataManager()
  
  private let artistDataManager = ArtistDataManager()
  private let dataService = SetlistDataService()
  var artistInfo: ArtistInfo?
  @AppStorage("isOnboarding") var isOnboarding: Bool?
  @Environment(NetworkMonitor.self) private var networkMonitor
  
  public init() { }
  
  public var body: some View {
    if networkMonitor.isConnected {
      ZStack(alignment: .bottom) {
        Color.gray6.ignoresSafeArea()
        VStack(spacing: 0) {
          ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
              onboardingTitle
              genresFilterButton
              artistNameButton
            }
          }
          bottomButton
        }
        
        if onboardingViewModel.isShowToastBar {
          ToastMessageView(message: onboardingViewModel.selectedArtist.count >= 5 ? "아티스트 5명이 모두 선택되었어요" : "아티스트를 선택해주세요", subMessage: nil, icon: "exclamationmark.circle.fill", color: Color.toast2)
            .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
            .padding(.bottom, 95)
            .padding(.horizontal, 24)
            .onAppear {
              DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                  onboardingViewModel.isShowToastBar.toggle()
                }
              }
            }
        }
      }
      .onAppear {
        dataManager.modelContext = modelContext
        artistFetchService.fetchData { success in
            if !success {
              onboardingViewModel.artistFetchError.toggle()
            }
        }
      }
    } else {
        NetworkUnavailableView()
    }
  }
  
  private var onboardingTitle: some View {
    VStack(alignment: .leading) {
      Spacer().frame(height: 70)
      Text("아티스트 찜하기")
        .font(.system(.title))
        .fontWeight(.bold)
        .foregroundStyle(Color.mainBlack)
      Spacer().frame(height: 16)
      Group {
        Text("관심 있는 아티스트의 세트리스트 정보를")
        Text("메인 화면에서 바로 확인할 수 있어요")
      }
      .font(.system(.footnote))
      .foregroundStyle(Color.gray)
      Spacer().frame(height: 24)
    }
    .padding(.leading, 24)
  }
  
  private var genresFilterButton: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        ForEach(OnboardingFilterType.allCases, id: \.self) { buttonType in
          Button {
            onboardingViewModel.selectedGenere = buttonType
          } label: {
            Text(buttonType.rawValue)
                  .fontWeight(onboardingViewModel.selectedGenere == buttonType ? .semibold : .regular)
              .font(.system(.subheadline))
              .padding(EdgeInsets(top: 9, leading: 10, bottom: 9, trailing: 10))
              .background(onboardingViewModel.selectedGenere == buttonType ? Color.mainBlack: Color.mainWhite)
              .cornerRadius(12)
              .foregroundStyle(onboardingViewModel.selectedGenere == buttonType ? Color.mainWhite: Color.mainBlack)
          }
        }
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 20)
    }
  }

  private var artistListView: some View {
    Group {
      if onboardingViewModel.artistFetchError {
      } else {
        artistNameButton
      }
    }
  }

  private var artistNameButton: some View {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
      ForEach(artistFetchService.allArtist.filter { artist in
        if onboardingViewModel.selectedGenere == .all { return true }
          if let tags = artist.tags, tags.contains(onboardingViewModel.findFilterTagName(onboardingViewModel.selectedGenere)) {
            return true
          }
          return false
      }, id: \.self) { item in
        Button {
          if let index = onboardingViewModel.selectedArtist.firstIndex(of: item) {
              onboardingViewModel.selectedArtist.remove(at: index)
          } else {
            if onboardingViewModel.selectedArtist.count < 5 {
              onboardingViewModel.selectedArtist.insert(item, at: 0)
            } else {
              onboardingViewModel.isShowToastBar.toggle()
            }
          }
        } label: {
          Rectangle()
            .frame(width: 125, height: 68)
            .foregroundStyle(.clear)
            .overlay {
              Text(item.name)
                .multilineTextAlignment(.center)
                .frame(width: 110, height: 48)          .font(.system(.largeTitle, weight: .semibold))
                .foregroundColor(onboardingViewModel.selectedArtist.contains(item) ? .mainBlack : Color(UIColor.systemGray3))
                .minimumScaleFactor(0.1)
                .padding(10)
            }
        }
        .buttonStyle(BasicButtonStyle())
      }
    }
    .padding(.horizontal, 7)
  }
  
  private var bottomButton: some View {
    ZStack {
      Button(action: {
        let artists = onboardingViewModel.selectedArtist.count
        if artists < 1 {
          onboardingViewModel.isShowToastBar.toggle()
        } else {
          for item in onboardingViewModel.selectedArtist {
            dataManager.addLikeArtist(name: item.name, country: item.country, alias: item.alias, mbid: item.mbid, gid: item.gid, imageUrl: item.url, songList: [])
          }
            isOnboarding = false
        }
      }, label: {
        RoundedRectangle(cornerRadius: 12)
          .frame(width: 342, height: 54)
          .foregroundColor(onboardingViewModel.selectedArtist.count < 1 ? .mainWhite : .mainBlack)
          .overlay {
//            Group {
//              onboardingViewModel.selectedArtist.count == 0 ? Text("아티스트 5명을 선택해주세요") : Text("\(Int(onboardingViewModel.selectedArtist.count))명 선택")
//
//            }
              Group {
                if onboardingViewModel.isKorean() {
                  onboardingViewModel.selectedArtist.count == 0 ? Text("아티스트 5명을 선택해주세요") : Text("\(Int(onboardingViewModel.selectedArtist.count))명 선택")
                } else {
                  let remainingArtists = 5 - Int(onboardingViewModel.selectedArtist.count)
                  if remainingArtists == 0 {
                    Text("Next")
                  } else if remainingArtists == 5{
                      Text("Select \(remainingArtists) artists")
                  }
                    else {
                    Text("Select \(remainingArtists) more")
                  }
                }
              }
            .foregroundStyle(onboardingViewModel.selectedArtist.count < 1 ? Color(UIColor.systemGray2) : Color.mainWhite)
              .font(.callout)
              .fontWeight(.bold)
          }
      })
      .padding(EdgeInsets(top: 0, leading: 24, bottom: 33, trailing: 24))
    }
  }
}

struct BasicButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
    }
}

#Preview {
  OnboardingView()
}
