//
//  TopBannerView.swift
//  Feature
//
//  Created by 장수민 on 10/11/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct TopBannerView: View {
    @State var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var selected = 2
    let screenHeight = UIScreen.main.bounds.size.height
    let screenWidth = UIScreen.main.bounds.size.width
    var body: some View {
        HStack {
            TeasingTabView(selectedTab: $selected, spacing: 6) {
                [
                    AnyView(TabContentView(mainText: "관심있는 아티스트의\n**세트리스트**를 찾아보세요", naviText: "아티스트 더 자세히 보기" )),
                    AnyView(TabContentView(mainText: "다녀온 아티스트의 \n**새로운 공연**을 확인해보세요.", naviText: "다른 세트리스트 보기" )),
                    AnyView(TabContentView(mainText: "관심있는 아티스트의\n**세트리스트**를 찾아보세요", naviText: "아티스트 더 자세히 보기" )),
                    AnyView(TabContentView(mainText: "다녀온 아티스트의 \n**새로운 공연**을 확인해보세요.", naviText: "다른 세트리스트 보기" )),
                    AnyView(TabContentView(mainText: "관심있는 아티스트의\n**세트리스트**를 찾아보세요", naviText: "아티스트 더 자세히 보기" )),
                    AnyView(TabContentView(mainText: "다녀온 아티스트의 \n**새로운 공연**을 확인해보세요.", naviText: "다른 세트리스트 보기" ))
                ]
            }
        }
    }
}
struct TeasingTabView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    @Binding var selectedTab: Int
    let spacing: CGFloat
    let views: () -> [AnyView]
    @State private var offset = CGFloat.zero
    @State var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var viewCount: Int { views().count }
    var body: some View {
            GeometryReader { _ in
                let width = screenWidth * 0.9
                LazyHStack(spacing: spacing) {
                    Color.clear
                        .frame(width: screenWidth * 0.05 - spacing)
                    ForEach(0..<viewCount, id: \.self) { idx in
                        views()[idx]
                            .frame(width: width)
                            .padding(.vertical)
                   }
                }
                .offset(x: CGFloat(-selectedTab) * (width + spacing) + offset)
                .animation(.easeOut, value: selectedTab)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offset = value.translation.width
                            timer.upstream.connect().cancel()
                        }
                        .onEnded { value in
                            withAnimation(.easeOut) {
                                offset = value.predictedEndTranslation.width
                                selectedTab -= Int((offset / width).rounded())
                                selectedTab = max(0, min(selectedTab, viewCount-1))
                                offset = 0
                                timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
                            }
                        }
                )
            }
        .onChange(of: selectedTab) {
                if selectedTab == 0 {
                    withAnimation {
                        selectedTab = 4
                    }
                }
            if selectedTab == 5 {
                    withAnimation(.linear) {
                        selectedTab = 1
                    }
                }
        }
        .onReceive(timer, perform: { _ in
            withAnimation {
                if selectedTab != 5 {
                    selectedTab += 1
                }
            }
        })
    }
}
struct TabContentView: View {
    let mainText: String
    let naviText: String
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(.init(mainText))
                            .multilineTextAlignment(.leading)
                            .padding(.bottom)
                            .font(.title3)
                    }
                    HStack {
                        Text(naviText)
                            .lineLimit(1)
                            .allowsTightening(true)
                        Image(systemName: "arrow.right")
                        Spacer()
                    }
            }
            .padding()
            .frame(height: screenHeight * 0.17)
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray)
        )
        }
}

#Preview {
    TopBannerView()
}

