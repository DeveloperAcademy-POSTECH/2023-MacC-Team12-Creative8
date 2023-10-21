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
  
  @State var userSelectionScreenMode: ScreenMode = ScreenMode(
    rawValue: UserDefaults.standard.integer(forKey: "displayMode")) ?? ScreenMode.system
  
  public var body: some View {
    ScrollView {
      ZStack {
        Color(.gray).ignoresSafeArea()
        VStack {
          HStack {
            Text("더보기")
              .font(.system(size: 24, weight: .semibold))
              .padding(EdgeInsets(top: 70, leading: 24, bottom: 1, trailing: 0))
            Spacer()
          }
          // 화면 모드 설정
          SectionBackgroundView(height: 322)
            .overlay {
              VStack(alignment: .leading) {
                SectionTitleView(
                  sectionTitle: "화면 모드 설정",
                  sectionDescription: "앱의 모드를 조정해서 방해받지 않는 콘서트 문화를 즐겨보세요.")
                Divider()
                
                // 시스템 설정 따르기
                ScreenModeSelectionButton(
                  modeName: "시스템 설정 따르기",
                  screenMode: .system,
                  userSelectionScreenMode: $userSelectionScreenMode)
                Divider()
                
                // 라이트 모드
                ScreenModeSelectionButton(
                  modeName: "라이트 모드",
                  screenMode: .light,
                  userSelectionScreenMode: $userSelectionScreenMode)
                Divider()
                
                // 다크 모드
                ScreenModeSelectionButton(
                  modeName: "다크 모드",
                  screenMode: .dark,
                  userSelectionScreenMode: $userSelectionScreenMode)
                .padding(.bottom, 10)
              }
              .padding(.horizontal, 26)
            }
            .padding(EdgeInsets(top: 32, leading: 20, bottom: 20, trailing: 20))
          
          // 세트리스트 추가 및 수정하기
          SectionBackgroundView(height: 239)
            .overlay {
              VStack(alignment: .leading) {
                SectionTitleView(
                  sectionTitle: "세트리스트 추가 및 수정하기",
                  sectionDescription: "Setlist.fm에서 다녀온 공연의 세트리스트를\n추가 및 수정하세요")
                SetlistfmLink(
                  setlistfmURL: "https://www.setlist.fm",
                  linkLabel: "Setlist.fm 바로가기")
                .padding(.bottom, 24)
              }
              .padding(.horizontal, 26)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
          
          // 서비스 이용 관련
          SectionBackgroundView(height: 300)
            .overlay {
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
                    .padding(.bottom, 10)
                }
              }
              .padding(.horizontal, 26)
            }
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
          
          // 문의하기
          AskView()
        }
      }
    }
    .ignoresSafeArea()
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

struct SectionTitleView: View {
  
  var sectionTitle: String
  var sectionDescription: String
  
  var body: some View {
    Text(sectionTitle)
      .font(.system(size: 16, weight: .semibold))
      .padding(.vertical, 32)
    Text(sectionDescription)
      .font(.footnote)
      .foregroundStyle(.gray)
      .padding(.bottom, 16)
  }
}

struct ScreenModeSelectionButton: View {
  
  var modeName: String
  var screenMode: ScreenMode
  
  @Binding var userSelectionScreenMode: ScreenMode
  
  var body: some View {
    Button {
      userSelectionScreenMode = screenMode
      saveDisplayMode()
    } label: {
      HStack {
        Image(systemName: userSelectionScreenMode == screenMode ? "checkmark.circle.fill" : "circle")
        Text(modeName)
          .foregroundStyle(.black)
          .font(.footnote)
        Spacer()
      }
      .padding(.vertical, 10)
    }
  }
  
  func saveDisplayMode() {
    UserDefaults.standard.set(userSelectionScreenMode.rawValue, forKey: "displayMode")
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
      .frame(width: 298, height: 56)
      .background(.thickMaterial)
      .foregroundStyle(.black)
      .clipShape(RoundedRectangle(cornerRadius: 14))
    })
  }
}

struct LinkLabelView: View {
  
  var linkLabel: String
  
  var body: some View {
    HStack {
      Text(linkLabel)
        .font(.footnote)
        .padding(.vertical, 20)
      Spacer()
      Image(systemName: "chevron.right")
        .resizable()
        .frame(width: 6, height: 12)
        .padding(EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 10))
    }
    .foregroundStyle(.black)
  }
}

#Preview {
  SettingView()
}
