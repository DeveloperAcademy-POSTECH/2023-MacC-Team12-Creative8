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
    @State var selectedIndex: Int?
    @State var scrollToIndex: Int?
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    logo
                    Spacer()
                    Button {
                        // 다크모드 기능 넣기
                    } label: {
                        Image(systemName: "moon.fill")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 38)
            }
            Divider()
                .padding(.leading, 24)
            artistNameScrollView
            VStack(spacing: 0) {
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
                                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 17, trailing: 13))
                                            }
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                                .padding(.bottom, 25)
                                ForEach(0 ..< sampleData[data].concertInfo.count, id: \.self) { item in
                                    let dDay = calculateDDay(from: sampleData[data].concertInfo[item].date)
                                        
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text("\(sampleData[data].concertInfo[item].date, formatter: dateFormatter)")
                                                .bold()
                                                .padding(.leading, 10)
                                                .padding(.vertical, 15)
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text(sampleData[data].concertInfo[item].tourName)
                                                    .bold()
                                                    .padding(.bottom, 2)
                                                Text(sampleData[data].concertInfo[item].venue)
                                            }
                                            .font(.system(size: 14))
                                            .padding(.leading, 43)
                                            Spacer()
                                            if dDay != "" {
                                                Text("\(dDay)")
                                                    .padding(10)
                                                    .background(RoundedRectangle(cornerRadius: 20)
                                                    .foregroundStyle(.gray))
                                            }
                                        }
                                    }
                                    Divider()
                                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                                }
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
                .scrollPosition(id: $scrollToIndex)
                .safeAreaPadding(.horizontal, 43)
                
            }
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
    public var logo: some View {
        Text("Logo")
            .font(.title)
            .bold()
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
                .onReceive(Just(scrollToIndex)) { index in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        scrollViewProxy.scrollTo(scrollToIndex, anchor: .leading)
                    }
                }
                .scrollTargetLayout()
            }
        }
        .scrollIndicators(.hidden)
        .safeAreaPadding(.leading, 43)
        .padding(.bottom, 20)
    }
    // 디데이 함수
    func calculateDDay(from date: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: date)
        
        if let day = components.day {
            if day == -1 {
                return "D-1"
            } else if day == 0 {
                return "오늘"
            }
        }
        return ""
    }
}
// 임시로 만든 데이터입니다. 나중에 swiftData로 바꾸면 될 것 같아요
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
