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
  @ObservedObject var onboardingViewModel = OnboardingViewModel()
  @ObservedObject var artistFetchService = ArtistFetchService()
  @ObservedObject var artistViewModel = ArtistViewModel()
  @Environment(\.modelContext) var modelContext
  @ObservedObject var dataManager = SwiftDataManager()
  
  private let artistDataManager = ArtistDataManager()
  private let dataService = SetlistDataService()
  var artistInfo: ArtistInfo?
  @AppStorage("isOnboarding") var isOnboarding: Bool?
  
  public init() {
  }
  
  public var body: some View {
    ZStack(alignment: .bottom) {
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
        toastBar
          .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
          .padding(.bottom, 120)
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
  }
  
  private var onboardingTitle: some View {
    VStack(alignment: .leading) {
      Spacer().frame(height: 70)
      Text("아티스트 찜하기")
        .font(.system(.headline))
        .foregroundStyle(Color.mainBlack)
      Spacer().frame(height: 16)
      Text("찜한 아티스트 중 최대 5명까지 메인화면에 나옵니다.\n메인 화면에 없는 아티스트는 보관함에서 확인해주세요.")
        .font(.system(.footnote))
        .foregroundStyle(Color.fontGrey2)
        .opacity(0.8)
      Spacer().frame(height: 48)
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
              .font(.system(.subheadline))
              .padding(10)
              .background(onboardingViewModel.selectedGenere == buttonType ? Color.mainBlack: Color.mainGrey1)
              .cornerRadius(12)
              .foregroundStyle(onboardingViewModel.selectedGenere == buttonType ? Color.settingTextBoxWhite: Color.fontGrey2)
          }
        }
      }
      .padding(.horizontal, 24)
      .padding(.bottom, 30)
    }
  }

  private var artistListView: some View {
    Group {
      if onboardingViewModel.artistFetchError {
        Text("서버가 터졌어용")
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
            onboardingViewModel.selectedArtist.insert(item, at: 0)
          }
        } label: {
          Rectangle()
            .frame(width: 125, height: 68)
            .foregroundStyle(.clear)
            .overlay {
              Text(item.name)
                .frame(width: 100, height: 48)
                .font(.system(.largeTitle, weight: .semibold))
                .foregroundColor(onboardingViewModel.selectedArtist.contains(item) ? .mainBlack : .fontGrey3)
                .minimumScaleFactor(0.01)
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
        if onboardingViewModel.selectedArtist.count < 3 {
          onboardingViewModel.isShowToastBar.toggle()
        } else {
          for item in onboardingViewModel.selectedArtist {
            dataManager.addLikeArtist(name: item.name, country: item.country, alias: item.alias, mbid: item.mbid, gid: item.gid, imageUrl: item.url, songList: [])
          }
            isOnboarding = false
        }
      }, label: {
        RoundedRectangle(cornerRadius: 14)
          .frame(width: 328, height: 54)
          .foregroundColor(onboardingViewModel.selectedArtist.count < 3 ? .mainGrey1 : .mainBlack)
          .overlay {
            Text(onboardingViewModel.selectedArtist.count == 0 ? "최소 3명 이상 선택" : "\(onboardingViewModel.selectedArtist.count)명 선택")
              .foregroundStyle(onboardingViewModel.selectedArtist.count < 3 ? Color.mainBlack : Color.settingTextBoxWhite)
              .font(.callout)
              .fontWeight(.bold)
          }
      })
      .padding(EdgeInsets(top: 0, leading: 31, bottom: 32, trailing: 31))
    }
  }
  
  private var toastBar: some View {
    RoundedRectangle(cornerRadius: 27)
      .frame(width: 328, height: 44)
      .foregroundColor(.toastBurn)
      .overlay {
        Text("아직 아티스트 3명이 선택되지 않았어요.")
          .foregroundStyle(Color.settingTextBoxWhite)
          .font(.subheadline)
          .fontWeight(.bold)
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
