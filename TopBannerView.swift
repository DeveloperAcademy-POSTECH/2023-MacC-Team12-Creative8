//
//  TopBannerView.swift
//  Feature
//
//  Created by 장수민 on 10/11/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

public struct TopBannerView: View {
    @State var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var scrollID: Int?
    public var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(BannerData.bannerData) { data in
                    NavigationLink(destination: Text("나중에 각각 맞는 상세페이지로 연결하기")) {
                        VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text(.init(data.mainText))
                                        .multilineTextAlignment(.leading)
                                        .padding(.bottom)
                                        .font(.title3)
                                }
                                HStack {
                                    Text(data.naviTitle)
                                        .lineLimit(1)
                                        .allowsTightening(true)
                                    Image(systemName: "arrow.right")
                                    Spacer()
                                }
                                .padding(.trailing)
                        }
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.gray)
                    )
                    }
                    .frame(width: 350)
                    .padding(.horizontal, 3) // navi
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .scrollPosition(id: $scrollID)
        .scrollIndicators(.never)
        .safeAreaPadding(.horizontal, 20)
        .onAppear {
            if !BannerData.bannerData.isEmpty {
                scrollID = BannerData.bannerData[2].id
            }
        }
        .gesture(
               DragGesture()
                   .onChanged {value in
                           timer.upstream.connect().cancel()
                   }
                   .onEnded{value in
                       timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
                   }
           )
        .onChange(of: scrollID) {
                if scrollID == BannerData.bannerData[0].id {
                    withAnimation {
                        scrollID = BannerData.bannerData[4].id
                    }
                }
                if scrollID == BannerData.bannerData[5].id {
                    withAnimation(.linear) {
                        scrollID = BannerData.bannerData[1].id
                    }
                }
            timer.upstream.connect().cancel()
            timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
        }
        .onReceive(timer) { _ in
            withAnimation {
                        scrollID! += 1
            }
        }
    }
}

struct BannerData: Identifiable {
    let id: Int
    let mainText: String
    let naviTitle: String
    static var bannerData: [BannerData] {
        [
        .init(id: 0, mainText: "관심있는 아티스트의\n**세트리스트**를 찾아보세요.", naviTitle: "아티스트 더 자세히 보기"),
        .init(id: 1, mainText: "다녀온 아티스트의 \n**새로운 공연**을 확인해보세요.", naviTitle: "다른 세트리스트 보기"),
        .init(id: 2, mainText: "관심있는 아티스트의\n**세트리스트**를 찾아보세요.", naviTitle: "아티스트 더 자세히 보기"),
        .init(id: 3, mainText: "다녀온 아티스트의 \n**새로운 공연**을 확인해보세요.", naviTitle: "다른 세트리스트 보기"),
        .init(id: 4, mainText: "관심있는 아티스트의\n**세트리스트**를 찾아보세요.", naviTitle: "아티스트 더 자세히 보기"),
        .init(id: 5, mainText: "다녀온 아티스트의 \n**새로운 공연**을 확인해보세요.", naviTitle: "다른 세트리스트 보기")
        ]
    }
}

#Preview {
    TopBannerView()
}

