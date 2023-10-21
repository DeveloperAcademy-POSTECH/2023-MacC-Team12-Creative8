//
//  MainView.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import Foundation
import SwiftUI
import Combine

public struct MainView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    @State private var isTapped: Bool = false
    
    let sampleData: [MainArchiveData] = [
        MainArchiveData(image: "malone", artist: "Post\nMalone", concertInfo: [
            ConcertInfo(date: Date(), tourName: "Tour 1-1", venue: "Venue 1-1"),
            ConcertInfo(date: Date(), tourName: "Tour 1-2", venue: "Venue 1-2"),
            ConcertInfo(date: Date(), tourName: "Tour 1-3", venue: "Venue 1-3")
        ]),
        MainArchiveData(image: "youngk", artist: "영케이", concertInfo: [
            ConcertInfo(date: Date(), tourName: "Tour 2-1", venue: "Venue 2-1"),
            ConcertInfo(date: Date(), tourName: "Tour 2-2", venue: "Venue 2-2"),
            ConcertInfo(date: Date(), tourName: "Tour 2-3", venue: "Venue 2-3")
        ]),
        MainArchiveData(image: "koc", artist: "Kings of\nConvenience", concertInfo: [
            ConcertInfo(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1)) ?? Date(), tourName: "Tour 3-1", venue: "Venue 3-1"),
            ConcertInfo(date: Date(), tourName: "Tour 3-2", venue: "Venue 3-2"),
            ConcertInfo(date: Date(), tourName: "Tour 3-3", venue: "Venue 3-3")
        ]),
        MainArchiveData(image: "woodz", artist: "Woodz", concertInfo: [
            ConcertInfo(date: Date(), tourName: "Tour 4-1", venue: "Venue 4-1"),
            ConcertInfo(date: Date(), tourName: "Tour 4-2", venue: "Venue 4-2"),
            ConcertInfo(date: Date(), tourName: "Tour 4-3", venue: "Venue 4-3")
        ])
    ]
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }
    let yearMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YY년 MM월"
        return formatter
    }()
    let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    @State var selectedIndex: Int?
    @State var scrollToIndex: Int?
    public init() {
    }
    public var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    logo
                    Spacer()
                    ZStack(alignment: .trailing) {
                        Button {
                            // 다크모드 기능 넣기
                            isTapped.toggle()
                        } label: {
                            Image(systemName: "moon.fill")
                            
                    }
                        .overlay {
                            if isTapped {
                                darkmodeButtons
                            }
                        }
                        
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical)
            Divider()
                .padding(.leading, 24)
                .padding(.vertical)
            if sampleData.isEmpty {
                EmptyMainView()
            } else {
                mainArtistsView
            }
        }

    }
    public var logo: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: 19, height: 20)
                .cornerRadius(50, corners: .bottomRight)
                .cornerRadius(50, corners: .bottomLeft)
            Rectangle()
                .frame(width: 18, height: 20)
                .cornerRadius(50, corners: .topRight)
                .cornerRadius(50, corners: .topLeft)

        }
    }
    public var darkmodeButtons: some View {
        HStack {
            Button {
                isTapped.toggle()
            } label: {
                VStack {
                    Image(systemName: "circle.lefthalf.filled")
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                    Text("시스템")
                        .font(.system(size: 10))
                        
                }
                .foregroundStyle(.black)
            }
            Button {
                isTapped.toggle()
            } label: {
                VStack {
                    Image(systemName: "moon")
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                    Text("라이트")
                        .foregroundStyle(.black)
                        .font(.system(size: 10))
                }
                .foregroundStyle(.black)
            }
            Button {
                isTapped.toggle()
            } label: {
                VStack {
                    Image(systemName: "moon.fill")
                        .padding(8)
                        .background(Color.white)
                        .clipShape(Circle())
                    Text("다크")
                        .foregroundStyle(.black)
                        .font(.system(size: 10))
                }
                .foregroundStyle(.black)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 16, bottom: 6, trailing: 16))
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 36))
        .frame(width: (screenWidth * 0.5), height: (screenWidth * 0.18))
        .offset(x: -(screenWidth * 0.16))
    }
    public var mainArtistsView: some View {
        VStack(spacing: 0) {
            artistNameScrollView
            ScrollView(.horizontal) {
                LazyHStack(spacing: 18) {
                    ForEach(0 ..< sampleData.count, id: \.self) { data in
                        VStack(spacing: 0) {
                            Button {
                                print("\(data)")
                            } label: {
                                Image(sampleData[data].image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: screenWidth * 0.78, height: screenWidth * 0.78)
                                    .overlay {
                                        ZStack {
                                            Color.black
                                                .opacity(0.2)
                                            VStack {
                                                Spacer()
                                                HStack {
                                                    Spacer()
                                                    Circle()
                                                        .frame(width: screenWidth * 0.15)
                                                        .foregroundStyle(.black)
                                                        .overlay {
                                                            Image(systemName: "arrow.right")
                                                                .foregroundStyle(.white)
                                                        }
                                                }
                                            }
                                            .padding([.trailing, .bottom])
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            }
                            ForEach(0 ..< sampleData[data].concertInfo.count, id: \.self) { item in
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        VStack {
                                            Text("\(sampleData[data].concertInfo[item].date, formatter: dayFormatter)")
                                                .bold()
                                                .font(.system(size: 26))
                                            Text("\(sampleData[data].concertInfo[item].date, formatter: yearMonthFormatter)")
                                                .padding(.leading, 10)
                                                .font(.system(size: 10))
                                                .foregroundStyle(.gray)
                                        }
                                        Spacer()
                                            .frame(width: screenWidth * 0.11)
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(sampleData[data].concertInfo[item].tourName)
                                                .bold()
                                                .padding(.bottom, 2)
                                            Text(sampleData[data].concertInfo[item].venue)
                                        }
                                        .font(.system(size: 14))
                                        Spacer()
                                    }
                                    .padding(.vertical)
                                    Divider()
                                }
                                .opacity(selectedIndex == data ? 1.0 : 0.5)
                            }
                        }
                    }
                }
                .scrollTargetLayout()
                
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollPosition(id: $scrollToIndex)
            .safeAreaPadding(.horizontal, screenWidth * 0.11)
            Spacer()
        }
        .onChange(of: scrollToIndex) {
            selectedIndex = scrollToIndex
        }
        .onAppear {
            if sampleData.count != 0 {
                selectedIndex = 0
                scrollToIndex = 0
            }
        }
    }
    public var artistNameScrollView: some View {
        ScrollView(.horizontal) {
            ScrollViewReader { scrollViewProxy in
                HStack(spacing: 54) {
                    ForEach(0..<sampleData.count, id: \.self) { data in
                        Text(.init(sampleData[data].artist))
                            .background(Color.clear)
                            .font(.system(size: 25))
                            .bold()
                            .id(data)
                            .foregroundColor(selectedIndex == data ? .black : .gray)
                            .animation(.easeInOut(duration: 0.2))
                            .onTapGesture {
                                withAnimation {
                                    selectedIndex = data
                                    scrollToIndex = data
                                }
                            }
                    }
                    Color.clear
                        .frame(width: screenWidth * 0.6)
                }
                .onReceive(Just(scrollToIndex)) { _ in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        scrollViewProxy.scrollTo(scrollToIndex, anchor: .leading)
                    }
                }
                .scrollTargetLayout()
            }
        }
        .frame(maxHeight: 60)
        .scrollIndicators(.hidden)
        .safeAreaPadding(.leading, screenWidth * 0.12)
    }
}
struct EmptyMainView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("찜한 아티스트가 없습니다")
                .font(.callout)
                .padding(.bottom)
            Text("관심있는 아티스트 정보를 빠르게\n확인하고 싶으시다면 찜을 해주세요")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundStyle(
                    .gray)
                .padding(.bottom)
            // TODO: 찜하기 화면 연결
            NavigationLink(destination: Text("아티스트 찜하기 이동")) {
                Text("아티스트 찜하러 가기 →")
                    .foregroundStyle(.white)
                    .font(.system(size: 14))
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 25.0)
                        .foregroundStyle(.black))
            }
            .padding(.vertical)
            Spacer()
            }
        }
}

// 로고 만들기
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
// MARK: 임시로 만든 데이터입니다. 나중에 swiftData로 바꾸면 될 것 같아요
struct ConcertInfo: Identifiable {
    var id = UUID()
    var date: Date
    var tourName: String
    var venue: String
}

struct MainArchiveData: Identifiable {
    var id = UUID()
    var image: String
    var artist: String
    var concertInfo: [ConcertInfo]
}

#Preview {
    MainView()
}
