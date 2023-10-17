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
                    HStack {
                        Spacer()
                        Text("이용 약관")
                            .font(.system(size: 19, weight: .semibold))
                            .padding(EdgeInsets(top: 70, leading: 0, bottom: 40, trailing: 0))
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                        .frame(height: 1050)
                        .overlay {
                            VStack(alignment: .leading) {
                                Text("서비스 이용 약관")
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(EdgeInsets(top: 32, leading: 0, bottom: 16, trailing: 0))
                                Divider()
                                
                                // 약관 상세 내용
                                VStack(alignment: .leading) {
                                    Text(viewModel.termsOfService[0])
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                        .padding(.top, 16)
                                    ForEach(1..<viewModel.termsOfService.count, id: \.self) { index in
                                        HStack(alignment: .top) {
                                            Text("\(index).")
                                            Text(viewModel.termsOfService[index])
                                        }
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                        .lineSpacing(4)
                                    }
                                }
                                .padding(.bottom, 53)
                            }
                            .padding(.horizontal, 26)
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct termsOfSetlistfm: View {
    
    @ObservedObject var viewModel = SettingViewModel()
    
    var body: some View {
        ZStack {
            Color(.gray).ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Text("Setlist.fm 약관")
                        .font(.system(size: 19, weight: .semibold))
                        .padding(EdgeInsets(top: 70, leading: 0, bottom: 40, trailing: 0))
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .frame(height: 571)
                    .overlay {
                        VStack(alignment: .leading) {
                            Text("Setlist.fm API 약관")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(EdgeInsets(top: 32, leading: 0, bottom: 16, trailing: 0))
                            Divider()
                            
                            // 약관 상세 내용
                            VStack(alignment: .leading) {
                                Text(viewModel.termsOfSelistfmAPI[0])
                                    .foregroundStyle(.gray)
                                    .font(.footnote)
                                    .padding(.top, 16)
                                ForEach(1..<viewModel.termsOfSelistfmAPI.count, id: \.self) { index in
                                    HStack(alignment: .top) {
                                        Text("•")
                                        Text(viewModel.termsOfSelistfmAPI[index])
                                    }
                                    .foregroundStyle(.gray)
                                    .font(.footnote)
                                    .lineSpacing(4)
                                }
                            }
                            
                            // Setlist.fm 약관 이동 버튼
                            Link(destination: URL(string: "https://www.setlist.fm/help/terms")!, label: {
                                HStack {
                                    Spacer()
                                    Text("Setlist.fm 약관 자세히 보기")
                                        .font(.system(.footnote, weight: .semibold))
                                    Spacer()
                                }
                                .frame(width: 298, height: 56)
                                .background(.thickMaterial)
                                .foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            })
                            .padding(EdgeInsets(top: 16, leading: 0, bottom: 35, trailing: 0))
                        }
                        .padding(.horizontal, 26)
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
            }
        }
    }
}

#Preview {
    termsOfSetlistfm()
}
