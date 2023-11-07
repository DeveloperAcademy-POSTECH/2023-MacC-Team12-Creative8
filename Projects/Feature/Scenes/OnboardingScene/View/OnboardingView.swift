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
  @ObservedObject var artistViewModel = ArtistViewModel()
  @Environment(\.modelContext) var modelContext
  @ObservedObject var dataManager = SwiftDataManager()
  
  private let artistDataManager: ArtistDataManager = ArtistDataManager.shared
  private let dataService: SetlistDataService = SetlistDataService.shared
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
      onboardingViewModel.readXslx()
      onboardingViewModel.updateFilteredModels()
    }
  }
  
  private var onboardingTitle: some View {
    VStack(alignment: .leading) {
      Image("logo", bundle: setaBundle)
        .resizable()
        .frame(width: 37, height: 21)
      Spacer().frame(height: 40)
      Text("아티스트 찜하기")
        .font(.system(.headline))
      Spacer().frame(height: 16)
      Text("찜한 아티스트 중 최대 5명까지 메인화면에 나옵니다.\n메인 화면에 없는 아티스트는 보관함에서 확인해주세요.")
        .font(.system(.footnote))
        .foregroundStyle(.black)
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
            onboardingViewModel.updateFilteredModels()
          } label: {
            Text(buttonType.rawValue)
              .font(.system(.subheadline))
              .padding(10)
              .background(onboardingViewModel.selectedGenere == buttonType ? .black: .gray)
              .cornerRadius(12)
              .foregroundStyle(onboardingViewModel.selectedGenere == buttonType ? .white: .black)
          }
        }
      }
      .padding(.leading, 24)
      .padding(.bottom, 30)
    }
  }
  
  private var artistNameButton: some View {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
      ForEach(onboardingViewModel.filteredArtist.indices, id: \.self) { index in
        Button {
          onboardingViewModel.artistSelectionAction(at: index)
        } label: {
          Rectangle()
            .frame(width: 125, height: 68)
            .foregroundStyle(.clear)
            .overlay {
              Text(onboardingViewModel.filteredArtist[index].name)
                .frame(width: 100, height: 48)
                .font(.system(size: 34, weight: .semibold))
                .foregroundColor(onboardingViewModel.selectedArtist.contains(where: { $0.id == onboardingViewModel.filteredArtist[index].id }) ? .black : .gray)
                .minimumScaleFactor(0.3)
            }
        }
      }
    }
    .padding(.horizontal, 7)
  }
  
  private var bottomButton: some View {
    ZStack {
      Button(action: {
        if onboardingViewModel.artistSelectedCount < 3 {
          onboardingViewModel.isShowToastBar.toggle()
        } else {
          for index in 0..<onboardingViewModel.selectedArtist.count {
            if self.artistInfo == nil {
              onboardingViewModel.getArtistInfo(
                artistName: onboardingViewModel.selectedArtist[index].name,
                artistMbid: onboardingViewModel.selectedArtist[index].mbid) { result in
                  if let result = result {
                    dataManager.addLikeArtist(name: result.name,
                                              country: "",
                                              alias: result.alias ?? "",
                                              mbid: result.mbid,
                                              gid: result.gid ?? 0,
                                              imageUrl: result.imageUrl,
                                              songList: [])
                }
              }
            }
          }
          DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            isOnboarding = false
          }
        }
        
      }, label: {
        RoundedRectangle(cornerRadius: 14)
          .frame(width: 328, height: 54)
          .foregroundColor(onboardingViewModel.artistSelectedCount < 3 ? .black : .blue)
          .overlay {
            Text(onboardingViewModel.artistSelectedCount == 0 ? "최소 3명 이상 선택" : "\(onboardingViewModel.artistSelectedCount)명 선택")
              .foregroundStyle(.white)
              .font(.callout)
              .fontWeight(.bold)
          }
          .padding(EdgeInsets(top: 0, leading: 31, bottom: 32, trailing: 31))
      })
    }
  }
  
  private var toastBar: some View {
    RoundedRectangle(cornerRadius: 14)
      .frame(width: 328, height: 54)
      .foregroundColor(.black)
      .overlay {
        Text("아직 아티스트 3명이 선택되지 않았어요.")
          .foregroundStyle(.white)
          .font(.callout)
          .fontWeight(.bold)
      }
  }
}

#Preview {
  OnboardingView()
}


