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
  
  @ObservedObject var viewModel = OnboardingViewModel()
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
      
      if viewModel.isShowToastBar {
        toastBar
          .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
          .padding(.bottom, 120)
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
              withAnimation {
                viewModel.isShowToastBar.toggle()
              }
            }
          }
      }
    }
    .onAppear {
      viewModel.readXslx()
      viewModel.updateFilteredModels()
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
            viewModel.selectedGenere = buttonType
            viewModel.updateFilteredModels()
          } label: {
            Text(buttonType.rawValue)
              .font(.system(.subheadline))
              .padding(10)
              .background(viewModel.selectedGenere == buttonType ? .black: .gray)
              .cornerRadius(12)
              .foregroundStyle(viewModel.selectedGenere == buttonType ? .white: .black)
          }
        }
      }
      .padding(.leading, 24)
      .padding(.bottom, 30)
    }
  }
  
  private var artistNameButton: some View {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
      ForEach(viewModel.filteredArtist.indices, id: \.self) { index in
        Button {
          viewModel.artistSelectionAction(at: index)
        } label: {
          Rectangle()
            .frame(width: 125, height: 68)
            .foregroundStyle(.clear)
            .overlay {
              Text(viewModel.filteredArtist[index].name)
                .frame(width: 100, height: 48)
                .font(.system(size: 34, weight: .semibold))
                .foregroundColor(viewModel.selectedArtist.contains(where: { $0.id == viewModel.filteredArtist[index].id }) ? .black : .gray)
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
        if viewModel.artistSelectedCount < 3 {
          viewModel.isShowToastBar.toggle()
        } else {
          isOnboarding = false
        }
      }, label: {
        RoundedRectangle(cornerRadius: 14)
          .frame(width: 328, height: 54)
          .foregroundColor(viewModel.artistSelectedCount < 3 ? .black : .blue)
          .overlay {
            Text(viewModel.artistSelectedCount == 0 ? "최소 3명 이상 선택" : "\(viewModel.artistSelectedCount)명 선택")
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
