//
//  SettingView.swift
//  Feature
//
//  Created by 예슬 on 2023/10/08.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

public struct SettingView: View {
  
  public init() {}
  
  public var body: some View {
      VStack {
        HStack {
          Text("더보기")
            .font(.system(size: 24, weight: .semibold))
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 11, trailing: 0))
          Spacer()
        }
        Divider()
          .padding(.leading, 24)
        
        // 세트리스트 추가 및 수정하기
        VStack(alignment: .leading) {
          SectionTitleView(
            sectionTitle: "세트리스트 추가 및 수정하기",
            sectionDescription: "Setlist.fm에서 다녀온 공연의 세트리스트를\n추가 및 수정하세요")
          SetlistfmLink(
            setlistfmURL: "https://www.setlist.fm",
            linkLabel: "Setlist.fm 바로가기")
          .padding(.bottom, 20)
          Divider()
        }
        .padding(.horizontal, 24)

        // 서비스 이용 관련
        VStack(alignment: .leading) {
          SectionTitleView(
            sectionTitle: "서비스 이용 관련",
            sectionDescription: "음악으로 연결되는 순간,\nSeta의 서비스 약관을 확인해보세요")
          Divider()
          
          // 이용 약관
          NavigationLink {
            ServiceExplainView()
              .navigationBarTitle("이용 약관", displayMode: .inline)
          } label: {
            LinkLabelView(linkLabel: "이용 약관")
          }
          Divider()
          
          // Setlist.fm 약관
          NavigationLink {
            TermsOfSetlistfm()
              .navigationBarTitle("Setlist.fm 약관", displayMode: .inline)
          } label: {
            LinkLabelView(linkLabel: "Setlist.fm 약관")
          }
          Divider()
          
          // 문의하기
          AskView()
        }
        .padding(.horizontal, 24)
      }
      .ignoresSafeArea()
  }
}

struct SectionTitleView: View {
  
  var sectionTitle: String
  var sectionDescription: String
  
  var body: some View {
    Text(sectionTitle)
      .font(.system(size: 20, weight: .semibold))
      .padding(EdgeInsets(top: 30, leading: 0, bottom: 30, trailing: 0))
    Text(sectionDescription)
      .font(.footnote)
      .foregroundStyle(.gray)
      .padding(.bottom, 16)
  }
}

struct SetlistfmLink: View {
  
  var setlistfmURL: String
  var linkLabel: String
  
  var body: some View {
    Link(destination: URL(string: setlistfmURL)!, label: {
      HStack {
        Spacer()
        Text(linkLabel)
          .font(.system(.footnote, weight: .semibold))
        Spacer()
      }
      .frame(height: 54)
      .background(.black)
      .foregroundStyle(.white)
      .clipShape(RoundedRectangle(cornerRadius: 14))
      .padding(.horizontal, 7)
    })
  }
}

struct LinkLabelView: View {
  
  var linkLabel: String
  
  var body: some View {
    HStack {
      Text(linkLabel)
        .font(.footnote)
        .padding(EdgeInsets(top: 20, leading: 26, bottom: 20, trailing: 0))
      Spacer()
      Image(systemName: "chevron.right")
        .resizable()
        .frame(width: 6, height: 12)
        .padding(EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 36))
    }
    .foregroundStyle(.black)
  }
}

#Preview {
  SettingView()
}
