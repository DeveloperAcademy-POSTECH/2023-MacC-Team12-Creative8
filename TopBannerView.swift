//
//  TopBannerView.swift
//  Feature
//
//  Created by 장수민 on 10/11/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

public struct TopBannerView: View {
    let items = BannerData.bannerData
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    @State var timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State private var currentIndex = 0 {
        didSet {
            scrollToCurrentPage()
        }
    }
    @State private var contentOffsetX: CGFloat = 0
    @State private var titleViewWidth: CGFloat = 0
    @State private var isLinkActive: Bool = false
    let spacing: CGFloat = 6
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                VStack(alignment: .trailing) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: spacing) {
                            Group {
                                ForEach(-1..<items.count + 1, id: \.self) { i in
                                    BannerTitleView(item: items[i < 0 ? items.count - 1 : (i >= items.count ? 0 : i)])
                                    .frame(width: titleViewWidth)
                                }
                            }
                        }
                        .offset(x: contentOffsetX + 8, y: 0)
                    }
                    .scrollDisabled(true)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { _ in
                        isLinkActive = false // DragGesture가 작동할 때 NavigationLink 비활성화
                    }
                    .onEnded { value in
                        isLinkActive = true
                        if value.translation.width < 0 {
                            currentIndex += 1
                        } else if value.translation.width > 0 {
                            currentIndex -= 1
                        }
                        timer.upstream.connect().cancel()
                        timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
                    }
            )
            .onAppear {
                titleViewWidth = screenWidth * 0.9
                contentOffsetX = -titleViewWidth + (spacing)
            }
            .onReceive(timer) { _ in
                currentIndex += 1
            }
        }
        .frame(width: screenWidth , height: screenHeight * 0.17)
    }
    private func scrollToCurrentPage() {
        if currentIndex == items.count {
            contentOffsetX = 0
            currentIndex = 0
        } else if currentIndex < 0 {
            contentOffsetX = -titleViewWidth * CGFloat(items.count+1) + spacing * CGFloat(items.count - 1)
            currentIndex = items.count - 1
        }
        withAnimation {
            contentOffsetX = -titleViewWidth * CGFloat(currentIndex+1) - spacing * CGFloat(currentIndex - 1)
        }
    }
}
#Preview {
    TopBannerView()
}
struct BannerTitleView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let item: BannerData
    @State var selection: String?
    
    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(.init(item.mainText))
                            .multilineTextAlignment(.leading)
                            .padding(.bottom)
                            .font(.title3)
                    }
                    HStack {
                        Text(item.naviTitle)
                            .lineLimit(1)
                            .allowsTightening(true)
                        Image(systemName: "arrow.right")
                        Spacer()
                    }
                    .padding(.trailing)
            }
            .onTapGesture {
                        selection = "배너를 눌렀다"
                    }
            .background {
                NavigationLink(destination: Text("이것은 어느 뷰?"), tag: "배너를 눌렀다", selection: self.$selection) {}
                    .disabled(true)
                    .opacity(0)
            }
                .foregroundColor(.black)
                .padding(EdgeInsets(top: 22, leading: 20, bottom: 28, trailing: 20))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.gray)
                )
            .frame(width: screenWidth * 0.9)
    }
}
struct BannerData: Identifiable {
    let id =  UUID()
    let mainText: String
    let naviTitle: String
    static var bannerData: [BannerData] {
        [
            .init(mainText: "관심있는 아티스트의\n**세트리스트**를 찾아보세요.", naviTitle: "아티스트 더 자세히 보기"),
            .init(mainText: "다녀온 아티스트의 \n**새로운 공연**을 확인해보세요.", naviTitle: "다른 세트리스트 보기"),
            .init(mainText: "관심있는 아티스트의\n**세트리스트**를 찾아보세요.", naviTitle: "아티스트 더 자세히 보기"),
            .init(mainText: "다녀온 아티스트의 \n**새로운 공연**을 확인해보세요.", naviTitle: "다른 세트리스트 보기"),
            .init(mainText: "관심있는 아티스트의\n**세트리스트**를 찾아보세요.", naviTitle: "아티스트 더 자세히 보기"),
            .init(mainText: "다녀온 아티스트의 \n**새로운 공연**을 확인해보세요.", naviTitle: "다른 세트리스트 보기")
        ]
    }
}
