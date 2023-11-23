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
  @State private var isButtonEnabled = true
  
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
//            genresFilterButton
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
      Spacer().frame(height: 70)
      Text("아티스트 찜하기")
        .font(.system(.headline))
        .foregroundStyle(Color.mainBlack)
      Spacer().frame(height: 16)
      Text("관심 있는 아티스트의 세트리스트 정보를\n메인 화면에서 바로 확인할 수 있어요")
        .font(.system(.footnote))
        .foregroundStyle(Color.fontGrey2)
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
              .background(onboardingViewModel.selectedGenere == buttonType ? Color.mainBlack: Color.mainGrey1)
              .cornerRadius(12)
              .foregroundStyle(onboardingViewModel.selectedGenere == buttonType ? Color.settingTextBoxWhite: Color.fontGrey2)
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
          if onboardingViewModel.artistSelectedCount > 5 && onboardingViewModel.selectedArtist.contains(where: { $0.id == onboardingViewModel.filteredArtist[index].id }) {
            onboardingViewModel.artistSelectionAction(at: index)
            onboardingViewModel.isShowToastBar.toggle()
          } else if onboardingViewModel.artistSelectedCount >= 5 && onboardingViewModel.selectedArtist.contains(where: { $0.id == onboardingViewModel.filteredArtist[index].id }) == false {
            onboardingViewModel.isShowToastBar.toggle()
          } else {
            onboardingViewModel.artistSelectionAction(at: index)
          }
        } label: {
              Text(onboardingViewModel.filteredArtist[index].name)
                .multilineTextAlignment(.center)
                .frame(width: 110, height: 48)
                .font(.system(.largeTitle, weight: .semibold))
                .foregroundColor(onboardingViewModel.selectedArtist.contains(where: { $0.id == onboardingViewModel.filteredArtist[index].id }) ? .mainBlack : .fontGrey3)
                .minimumScaleFactor(0.1)
                .padding(10)
        }
        .buttonStyle(BasicButtonStyle())
      }
    }
    .padding(.horizontal, 7)
    .padding(.vertical, 10)
  }
  
  private var bottomButton: some View {
    ZStack {
      Button(action: {
        if onboardingViewModel.artistSelectedCount >= 1 && onboardingViewModel.artistSelectedCount <= 5 {
          isButtonEnabled = false
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
        } else if onboardingViewModel.artistSelectedCount > 5 {
          onboardingViewModel.isShowToastBar.toggle()
        }
      }, label: {
        RoundedRectangle(cornerRadius: 14)
          .frame(width: 328, height: 54)
          .foregroundColor(onboardingViewModel.artistSelectedCount < 1 ? .mainGrey1 : .mainBlack)
          .overlay {
            Text(onboardingViewModel.artistSelectedCount == 0 ? "5명까지 선택할 수 있습니다" : "\(onboardingViewModel.artistSelectedCount)명 선택")
              .foregroundStyle(onboardingViewModel.artistSelectedCount < 1 ? Color.mainBlack : Color.settingTextBoxWhite)
              .font(.callout)
              .fontWeight(.bold)
          }
      })
      .padding(EdgeInsets(top: 0, leading: 31, bottom: 32, trailing: 31))
      .disabled(!isButtonEnabled)
    }
  }
  
  private var toastBar: some View {
    RoundedRectangle(cornerRadius: 27)
      .frame(width: 328, height: 44)
      .foregroundColor(.toastBurn)
      .overlay {
        Text("아티스트는 5명까지 선택할 수 있어요")
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
