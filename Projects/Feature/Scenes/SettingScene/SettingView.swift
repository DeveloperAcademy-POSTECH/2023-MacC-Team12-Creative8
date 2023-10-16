//
//  SettingView.swift
//  Feature
//
//  Created by 예슬 on 2023/10/08.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

public struct SettingView: View {
    
    enum SettingSelected {
        case system
        case light
        case dark
    }
    
    public init() {}

    @State var userSelectionScreenMode: ScreenMode = .system
    @State var showModal = false
    
    public var body: some View {
        //NavigationStack {
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
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .frame(height: 322)
                            .overlay {
                                VStack(alignment: .leading) {
                                    Text("화면 모드 설정")
                                        .font(.system(size: 16, weight: .semibold))
                                        .padding(.vertical, 32)
                                    Text("앱의 모드를 조정해서 방해받지 않는 콘서트\n문화를 즐겨보세요.")
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                        .padding(.bottom, 16)
                                    Divider()
                                    
                                    // 시스템 설정 따르기
                                    ScreenModeSelectionButton(modeName: "시스템 설정 따르기", screenMode: .system, settingSelected: $userSelectionScreenMode)
                                    Divider()
                                    
                                    // 밝은 모드
                                    ScreenModeSelectionButton(modeName: "라이트 모드", screenMode: .light, settingSelected: $userSelectionScreenMode)
                                    Divider()
                                    
                                    // 어두운 모드
                                    ScreenModeSelectionButton(modeName: "다크 모드", screenMode: .dark, settingSelected: $userSelectionScreenMode)
                                        .padding(.bottom, 10)
                                }
                                .padding(.horizontal, 26)
                            }
                            .padding(EdgeInsets(top: 32, leading: 20, bottom: 20, trailing: 20))
                        
                        // 세트리스트 추가 및 수정하기
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .frame(height: 239)
                            .overlay {
                                VStack(alignment: .leading) {
                                    Text("세트리스트 추가 및 수정하기")
                                        .font(.system(size: 16, weight: .semibold))
                                        .padding(.vertical, 32)
                                    Text("Setlist.fm에서 다녀온 공연의 세트리스트를\n추가 및 수정하세요")
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                        .padding(.bottom, 29)
                                    Link(destination: URL(string: "https://www.setlist.fm")!, label: {
                                        HStack {
                                            Spacer()
                                            Text("Setlist.fm 바로가기")
                                                .font(.system(.footnote, weight: .semibold))
                                            Spacer()
                                        }
                                        .frame(width: 298, height: 56)
                                        .background(.thickMaterial)
                                        .foregroundStyle(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                    })
                                    .padding(.bottom, 24)
                                }
                                .padding(.horizontal, 26)
                            }
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                        
                        // 서비스 이용 관련
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .frame(height: 270)
                            .overlay {
                                VStack(alignment: .leading) {
                                    Text("서비스 이용 관련")
                                        .font(.system(size: 16, weight: .semibold))
                                        .padding(.vertical, 30)
                                    Text("아무런 아무런 말말말말말말말말말이랍니다.\n그냥 이런저런 텍스트일테지요.")
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                        .padding(.bottom, 16)
                                    Divider()
                                    
                                    // 이용 약관
                                    NavigationLink {
                                        Text("이용 약관")
                                    } label: {
                                        HStack {
                                            Text("이용 약관")
                                                .font(.footnote)
                                                .padding(.vertical, 10)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .frame(width: 6, height: 12)
                                                .padding(EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 10))
                                        }
                                        .foregroundStyle(.black)
                                    }
                                    Divider()
                                    
                                    // Setlist.fm 약관
                                    NavigationLink {
                                        Text("Setlist.fm 약관")
                                    } label: {
                                        HStack {
                                            Text("Setlist.fm 약관")
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
                                .padding(.horizontal, 26)
                            }
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 20, trailing: 20))
                        
                        // 문의하기
//                        RoundedRectangle(cornerRadius: 12)
//                            .fill(.white)
//                            .frame(width: 350, height: 66)
                            //.overlay {
                                AskView()
                            //}
                            //.padding(.bottom, 91)
                    }
                }
            }
            .ignoresSafeArea()
        //}
    }
}

struct ScreenModeSelectionButton: View {
    
    var modeName: String
    var screenMode: ScreenMode
    
    @Binding var settingSelected: ScreenMode
    
    var body: some View {
        Button {
            settingSelected = screenMode
        } label: {
            HStack{
                Image(systemName: settingSelected == screenMode ? "checkmark.circle.fill" : "circle")
                Text(modeName)
                    .foregroundStyle(.black)
                    .font(.footnote)
                Spacer()
            }
            .padding(.vertical, 10)
        }
    }
}


#Preview {
    SettingView()
}
