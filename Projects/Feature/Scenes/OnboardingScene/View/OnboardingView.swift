//
//  OnboardingView.swift
//  Feature
//
//  Created by 예슬 on 2023/10/21.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import CoreXLSX

struct OnboardingView: View {
  
  @ObservedObject var viewModel = OnboardingViewModel()
  @State var selectedArtistCount: Int = 0
  @State var showToastBar: Bool = false
  
  var body: some View {
    ZStack(alignment: .bottom) {
      VStack(spacing: 0) {
        ScrollView(showsIndicators: false) {
          VStack(alignment: .leading, spacing: 0) {
            OnboardingTitle()
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(viewModel.genres, id: \.self) { genre in
                  GenreButton(genre: genre)
                }
              }
              .padding(EdgeInsets(top: 0, leading: 24, bottom: 40, trailing: 0))
            }
            ArtistSelectionView(selectedArtistCount: $selectedArtistCount, artists: viewModel.artists)
          }
        }
        BottomButton(selectedArtistCount: $selectedArtistCount, showToastBar: $showToastBar)
      }
      if showToastBar {
        ToastBar()
          .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
          .padding(.bottom, 120)
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
              withAnimation {
                showToastBar.toggle()
              }
            }
          }
      }
    }
 
  }
}

struct OnboardingTitle: View {
  var body: some View {
    VStack(alignment: .leading) {
      Text("아티스트 찜하기")
        .font(.system(size: 24, weight: .bold))
        .padding(.bottom, 10)
      Text("관심있는 아티스트를 찜하고\n공연 및 세트리스트 정보를 빠르게 확인해보세요")
        .font(.system(size: 14))
        .foregroundStyle(.black)
        .opacity(0.8)
    }
    .padding(EdgeInsets(top: 0, leading: 24, bottom: 48, trailing: 0))
  }
}

struct GenreButton: View {
  
  @State var isSelected: Bool = false
  var genre: String
  
  var body: some View {
    Button {
      isSelected.toggle()
    } label: {
      Text(genre)
        .frame(height: 30)
        .padding(10)
        .background(isSelected ? .black: .gray)
        .cornerRadius(12)
        .foregroundStyle(isSelected ? .white: .black)
    }
  }
}

struct ArtistButton: View {
  
  @State var isSelected: Bool = false
  @Binding var selectedArtistCount: Int
  var artistName: String
  
  var body: some View {
    Button {
      isSelected.toggle()
      if isSelected {
        selectedArtistCount += 1
      } else {
        selectedArtistCount -= 1
      }
    } label: {
      Rectangle()
        .frame(width: 125, height: 68)
        .foregroundStyle(.clear)
        .overlay {
          Text(artistName)
            .frame(width: 100, height: 48)
            .font(.system(size: 34, weight: .semibold))
            .foregroundColor(isSelected ? .black : .gray)
            .minimumScaleFactor(0.3)
        }
    }
  }
}

struct ArtistSelectionView: View {
  @Binding var selectedArtistCount: Int
  let artists: [String]
  
  var body: some View {
    LazyVStack(spacing: 0) {
      ForEach(0..<12) { index in
        ArtistRow(index: index, artists: artists, selectedArtistCount: $selectedArtistCount)
      }
    }
  }
}

struct ArtistRow: View {
  let index: Int
  let artists: [String]
  @Binding var selectedArtistCount: Int
  
  var body: some View {
    HStack(spacing: 0) {
      ForEach(0..<3) { subIndex in
        ArtistButton(selectedArtistCount: $selectedArtistCount, artistName: artists[index * 3 + subIndex])
      }
    }
    .padding(index % 2 == 0 ? .leading : .trailing, 18)
    .padding(.bottom, 20)
  }
}

struct BottomButton: View {
  
  @Binding var selectedArtistCount: Int
  @Binding var showToastBar: Bool
  
  var body: some View {
    ZStack {
      Button(action: {
        if selectedArtistCount < 3 {
          showToastBar.toggle()
        }
      }, label: {
        RoundedRectangle(cornerRadius: 14)
          .frame(width: 328, height: 54)
          .foregroundColor(selectedArtistCount > 2 ? .blue : .black)
          .overlay {
            Text(selectedArtistCount == 0 ? "최소 3명 이상 선택" : "\(selectedArtistCount)명 선택")
              .foregroundStyle(.white)
              .font(.callout)
              .fontWeight(.bold)
          }
          .padding(EdgeInsets(top: 0, leading: 31, bottom: 32, trailing: 31))
      })
    }
  }
}

struct ToastBar: View {
  var body: some View {
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
