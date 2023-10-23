//
//  ServiceExplainView.swift
//  Feature
//
//  Created by 예슬 on 2023/10/16.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct ServiceExplainView: View {
  
  @ObservedObject var viewModel = SettingViewModel()
  
  var body: some View {
    ScrollView {
      ZStack {
        Color(.gray)
        VStack {
          SectionBackgroundView(height: 1100)
            .overlay {
              VStack(alignment: .leading) {
                TermsTitleView(title: "서비스 이용 약관")
                
                // 약관 상세 내용
                TermsView(terms: viewModel.termsOfService, bulletPoint: "")
                  .padding(.bottom, 53)
              }
              .padding(.horizontal, 26)
            }
            .padding(EdgeInsets(top: 132, leading: 20, bottom: 40, trailing: 20))
        }
      }
    }
    .ignoresSafeArea()
  }
}

struct TermsOfSetlistfm: View {
  
  @ObservedObject var viewModel = SettingViewModel()
  
  var body: some View {
    ZStack {
      Color(.gray).ignoresSafeArea()
      VStack {
        SectionBackgroundView(height: 571)
          .overlay {
            VStack(alignment: .leading) {
              TermsTitleView(title: "Setlist.fm API 약관")
              
              // 약관 상세 내용
              TermsView(terms: viewModel.termsOfSelistfmAPI, bulletPoint: "•")
              
              // Setlist.fm 약관 이동 버튼
              SetlistfmLink(
                setlistfmURL: "https://www.setlist.fm/help/terms",
                linkLabel: "Setlist.fm 약관 자세히 보기")
              .padding(EdgeInsets(top: 16, leading: 0, bottom: 35, trailing: 0))
            }
            .padding(.horizontal, 26)
          }
          .padding(EdgeInsets(top: 0, leading: 20, bottom: 80, trailing: 20))
      }
    }
  }
}

struct TermsTitleView: View {
  
  var title: String
  
  var body: some View {
    Text(title)
      .font(.system(size: 16, weight: .semibold))
      .padding(EdgeInsets(top: 32, leading: 0, bottom: 16, trailing: 0))
    Divider()
  }
}

struct TermsView: View {
  
  @ObservedObject var viewModel = SettingViewModel()
  
  var terms: [String]
  var bulletPoint: String
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(terms[0])
        .foregroundStyle(.gray)
        .font(.footnote)
        .padding(.top, 16)
      ForEach(1..<terms.count, id: \.self) { index in
        HStack(alignment: .top) {
          Text(bulletPoint == "•" ? bulletPoint : "\(index).")
          Text(terms[index])
        }
        .foregroundStyle(.gray)
        .font(.footnote)
        .lineSpacing(4)
      }
    }
  }
}

struct SectionBackgroundView: View {
  
  var height: CGFloat
  
  var body: some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(.white)
      .frame(height: height)
  }
}


#Preview {
  ServiceExplainView()
}
