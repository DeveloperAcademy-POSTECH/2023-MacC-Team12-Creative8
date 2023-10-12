//
//  SettingView.swift
//  Feature
//
//  Created by 예슬 on 2023/10/08.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct SettingView: View {
    
    enum SettingSelected {
        case system
        case light
        case dark
    }
    
    @State var settingSelected: SettingSelected = .system
    @State var showModal = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    Color(.gray).ignoresSafeArea()
                    VStack {
                        HStack {
                            Text("더보기")
                                .font(.system(size: 24, weight: .semibold))
                                .padding(EdgeInsets(top: 70, leading: 24, bottom: 30, trailing: 0))
                            Spacer()
                        }
                        // 화면 모드 설정
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .frame(width: 350, height: 322)
                            .overlay {
                                VStack(alignment: .leading) {
                                    Text("화면 모드 설정")
                                        .font(.system(size: 16, weight: .semibold))
                                    Spacer()
                                    Text("앱의 모드를 조정해서 방해받지 않는 콘서트\n문화를 즐겨보세요.")
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                    Divider()
                                    // 시스템 설정 따르기
                                    Button {
                                        settingSelected = .system
                                    } label: {
                                        HStack {
                                            Image(systemName: settingSelected == .system ? "checkmark.circle.fill" : "circle")
                                            Text("시스템 설정 따르기")
                                                .foregroundStyle(.black)
                                                .font(.footnote)
                                            Spacer()
                                        }
                                        .padding(.vertical, 10)
                                    }
                                    Divider()
                                    // 밝은 모드
                                    Button {
                                        settingSelected = .light
                                    } label: {
                                        HStack{
                                            Image(systemName: settingSelected == .light ? "checkmark.circle.fill" : "circle")
                                            Text("밝은 모드")
                                                .foregroundStyle(.black)
                                                .font(.footnote)
                                            Spacer()
                                        }
                                        .padding(.vertical, 10)
                                    }
                                    Divider()
                                    // 어두운 모드
                                    Button {
                                        settingSelected = .dark
                                    } label: {
                                        HStack{
                                            Image(systemName: settingSelected == .dark ? "checkmark.circle.fill" : "circle")
                                            Text("어두운 모드")
                                                .foregroundStyle(.black)
                                                .font(.footnote)
                                            Spacer()
                                        }
                                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 15, trailing: 0))
                                    }
                                }
                                .padding(26)
                            }
                            .padding(.bottom, 20)
                        
                        // 음악 앱 선택하기
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .frame(width: 350, height: 309)
                            .overlay {
                                VStack(alignment: .leading) {
                                    Text("음악 앱 선택하기")
                                        .font(.system(size: 16, weight: .semibold))
                                    Spacer()
                                    Text("내가 좋아하는 세트리스트를 현재 사용하고 있는\n음악 앱 플레이리스트로 바로 옮겨보세요. ")
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                    Spacer()
                                    Button {
                                        
                                    } label: {
                                        HStack {
                                            Spacer()
                                            Image(systemName: "photo.circle")
                                            Spacer()
                                            Text("Apple Music으로 연동하기")
                                                .font(.system(.footnote, weight: .semibold))
                                            Spacer()
                                            Spacer()
                                        }
                                        .frame(width: 315, height: 54)
                                        .background(.thickMaterial)
                                        .foregroundStyle(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                    }
                                    Spacer()
                                    Divider()
                                    Spacer()
                                    Text("이 버전에서는 Apple Music만 지원하고 있습니다. 추가 지원되는\n음악 앱은 버전 업데이트를 기다려주세요.")
                                        .font(.caption2)
                                        .lineSpacing(5)
                                        .foregroundStyle(.gray)
                                }
                                .padding(26)
                            }
                            .padding(.bottom, 20)
                        
                        // 서비스 이용 관련
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .aspectRatio(contentMode: .fit)
                            .overlay {
                                VStack(alignment: .leading) {
                                    Text("서비스 이용 관련")
                                        .font(.system(size: 16, weight: .semibold))
                                        .padding(.bottom, 32)
                                    Text("아무런 아무런 말말말말말말말말말이랍니다.\n그냥 이런저런 텍스트일테지요.")
                                        .font(.footnote)
                                        .foregroundStyle(.gray)
                                    Divider()
                                    // 이용 약관
                                    NavigationLink {
                                        Text("이용 약관")
                                    } label: {
                                        HStack {
                                            Text("이용 약관")
                                                .font(.footnote)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .frame(width: 6, height: 12)
                                        }
                                        .foregroundStyle(.black)
                                        .padding(.vertical, 18)
                                    }
                                    Divider()
                                    // Setlist.fm 약관
                                    NavigationLink {
                                        Text("Setlist.fm 약관")
                                    } label: {
                                        HStack {
                                            Text("Setlist.fm 약관")
                                                .font(.footnote)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .frame(width: 6, height: 12)
                                        }
                                        .foregroundStyle(.black)
                                        .padding(.vertical, 18)
                                    }
                                    Divider()
                                    // 개발자 정보
                                    NavigationLink {
                                        Text("개발자 정보")
                                    } label: {
                                        HStack {
                                            Text("개발자 정보")
                                                .font(.footnote)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .frame(width: 6, height: 12)
                                        }
                                        .foregroundStyle(.black)
                                        .padding(.vertical, 18)
                                    }
                                }
                                .padding(26)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        
                        // 문의하기
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .frame(width: 350, height: 66)
                            .overlay {
                                Button {
                                    showModal.toggle()
                                } label: {
                                    HStack {
                                        Text("문의하기")
                                            .font(.system(.footnote, weight: .semibold))
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .frame(width: 6, height: 12)
                                    }
                                    .foregroundStyle(.black)
                                    .padding(26)
                                }
                                .sheet(isPresented: $showModal, content: {
                                    Text("문의하기")
                                })
                            }
                            .padding(.bottom, 91)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}


#Preview {
    SettingView()
}
