//
//  MainView.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import Foundation
import SwiftUI

public struct MainView: View {
    // 임시로 만들어둔 데이터입니다.
    let upcomingEvents: [UpcomingEvent] = [
        UpcomingEvent(singer: "Kings of Convenience", date: "2023. 10. 07", dDay: "D - 1", image: "postmalone"),
        UpcomingEvent(singer: "NCT 127", date: "2023. 10. 07", dDay: "D - 1", image: "nct127"),
        UpcomingEvent(singer: "방탄소년단", date: "2023. 10. 07", dDay: "D - 1", image: "bts")
    ]
    // 임시로 만들어둔 데이터입니다.
    let archivedNum: Int = 4
    let singer: String = "Post Malone"
    let concertName: String = "If Ya’ll Weren’t Here, I’d Be Crying"
    let dDay: String = "D-20"
    let month: String = "10월"
    let day: String = "27"
    let image: String = "postmalone"
    @State private var scrollID: Int?
    public init() {}
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("Logo")
                            .font(.title)
                            .bold()
                        Spacer()
                        Button {
                            // 다크모드 기능 넣기
                        } label: {
                            Image(systemName: "moon.fill")
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                        .frame(height: 25)
                    TopBannerView()
                    .padding(.bottom, 48)
                    HStack {
                        Text("내가 찜한 공연")
                        .bold()
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 6) {
                            ForEach(0..<archivedNum, id: \.self) { _ in
                                VStack(alignment: .leading, spacing: 0) {
                                    MainBookmarkedView(archivedNum: archivedNum
                                                       , singer: singer, concertName: concertName, dDay: dDay
                                                       , month: month, day: day, image: image)
                                }
                            }
                        }
                        .scrollTargetLayout()
                        .safeAreaPadding(.horizontal, 20)
                        .background(.yellow)
                        .onAppear {
                            if archivedNum != 0 {
                                scrollID = 0
                            }
                        }
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                    .scrollPosition(id: $scrollID)
                    HStack(spacing: 8) {
                        ForEach(0..<archivedNum, id: \.self) { pageIndex in
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundColor(scrollID == pageIndex ? .black : .gray)
                                .animation(.easeInOut(duration: 0.3))
                                .onTapGesture {
                                    withAnimation {
                                        scrollID = pageIndex
                                    }
                                }
                        }
                        .padding(.vertical, 18)
                    }
                        .padding(.bottom, 48)
                    VStack(alignment: .leading) {
                        Text("다가오는 공연")
                            .padding(.bottom, 20)
                            .bold()
                        LazyVStack {
                            ForEach(upcomingEvents) { concert in
                                UpcomingConcertsView(singer: concert.singer, image: concert.image
                                                     , date: concert.date, dDay: concert.dDay)
                                    .padding(.bottom, 9)
                            }
                        }
                        NavigationLink(destination: Text("안녕")) {
                            HStack {
                                Spacer()
                                Text("더 많은 콘서트 일정 보러가기")
                                Image(systemName: "arrow.right")
                            }.font(.footnote)
                                .foregroundColor(.black)
                        }
                        .padding(.bottom, 48)
                        Text("인기 아티스트")
                            .bold()
                            .padding(.bottom, 20)
                        PopularArtistsView(singer: "블랙핑크", image: "blackpink",
                                           day1: "02", month1: "11월", venue1: "KINTEX, Goyang-si,South Korea",
                                           day2: "02", month2: "11월", venue2: "KINTEX, Goyang-si, South Korea",
                                           day3: "02", month3: "11월", venue3: "KINTEX, Goyang-si,South Korea")
                            .padding(.bottom, 9)
                        NavigationLink(destination: Text("안녕")) {
                            HStack {
                                Spacer()
                                Text("블랙핑크의 세트리스트 보기")
                                Image(systemName: "arrow.right")
                            }.font(.footnote)
                                .foregroundColor(.black)
                        }
                        .padding(.bottom, 30)
                        PopularArtistsView(singer: "방탄소년단", image: "bts",
                                           day1: "02", month1: "11월", venue1: "KINTEX, Goyang-si,South Korea",
                                           day2: "02", month2: "11월", venue2: "KINTEX, Goyang-si, South Korea",
                                           day3: "02", month3: "11월", venue3: "KINTEX, Goyang-si,South Korea")
                            .padding(.bottom, 9)
                        NavigationLink(destination: Text("안녕")) {
                            HStack {
                                Spacer()
                                Text("블랙핑크의 세트리스트 보기")
                                Image(systemName: "arrow.right")
                            }.font(.footnote)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 28)
            }
        }
    }
    struct UpcomingConcertsView: View {
        let singer: String
        let image: String
        let date: String
        let dDay: String
        var body: some View {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray)
                HStack {
                    VStack(alignment: .leading) {
                        Text(.init(singer))
                        Text(.init(date))
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.white)
                                .frame(maxWidth: 70)
                                .overlay(
                                Text(dDay)
                                )
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: 141)
                .padding(20)
                Image(.init(image))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 290)
                            .mask(
                                RoundedRectangle(cornerRadius: 90)
                                    .frame(width: 280, height: 160)
                                    .rotationEffect(Angle(degrees: 15))
                                    .position(CGPoint(x: 140, y: 120))
                            )
                            .position(CGPoint(x: 280, y: 90))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .frame(height: 131)
        }
    }
}

struct UpcomingEvent: Identifiable {
    let id = UUID()
    let singer: String
    let date: String
    let dDay: String
    let image: String
}

#Preview {
    MainView()
}
