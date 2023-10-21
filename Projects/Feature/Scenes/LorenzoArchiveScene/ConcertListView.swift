//
//  ConcertListView.swift
//  Feature
//
//  Created by 장수민 on 10/22/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct ConcertListView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    @ObservedObject var viewModel = ConcertListViewModel()
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            ForEach(0 ..< viewModel.concertYears.count, id: \.self) { concert in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(viewModel.concertYears[concert])
                            .bold()
                        .padding(.vertical, 28.5)
                        Spacer()
                        // MARK: 연도별 뷰로 연결해주시면 됩니다...
                        NavigationLink(destination: Text("연도별 뷰로 연결해주시믄 됩니다...")) {
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(.horizontal, 10)
                    Divider()
                    // 연도별 공연
                    ForEach(0 ..< viewModel.sampleBookmarkedConcerts.filter {
                        Calendar.current.component(.year, from: $0.date) ==
                        Int(viewModel.concertYears[concert]) }.count, id: \.self) { concert in
                            // 월.일
                            let formattedDate = 
                            viewModel.dateFormatter.string(from: viewModel.sampleBookmarkedConcerts[concert].date)
                            // 요일
                            let dayOfWeek = 
                            viewModel.dayOfWeekFormatter.string(from: viewModel.sampleBookmarkedConcerts[concert].date)
                            VStack(alignment: .leading , spacing: 0) {
                                // MARK: 세트리스트 뷰로 연결해주시면 됩니다...
                                NavigationLink(destination: Text(viewModel.sampleBookmarkedConcerts[concert].artist)) {
                                    HStack(spacing: 0) {
                                        VStack(spacing: 0) {
                                            Text(formattedDate)
                                                .foregroundStyle(.black)
                                                .font(.callout)
                                                .bold()
                                            Text(dayOfWeek)
                                                .foregroundStyle(.gray)
                                                .font(.callout)
                                        }
                                        .padding(.trailing)
                                        VStack(alignment: .leading, spacing: 0) {
                                            // 아티스트
                                            Text(viewModel.sampleBookmarkedConcerts[concert].artist)
                                                .bold()
                                            // 공연 이름
                                            Text(viewModel.sampleBookmarkedConcerts[concert].tourName)
                                                .bold()
                                            // 장소
                                            Text(viewModel.sampleBookmarkedConcerts[concert].venue)
                                        }
                                        .foregroundStyle(.black)
                                        .font(.system(size: 14))
                                        .padding(.leading)
                                    }
                                }
                                .padding(.vertical)
                                .padding(.horizontal)
                                Divider()
                            }
                    }
                }
            }
            Spacer()
                .frame(height: screenHeight * 0.14)
        }
        .padding(.horizontal, 20)
        .onAppear {
            viewModel.concertYears = viewModel.getAllConcertYears(concerts: viewModel.sampleBookmarkedConcerts)
        }
    }
}

#Preview {
    ConcertListView()
}
//  MARK: 임시로 만든 북마크 모델입니다. 나중에 swiftData로 바꾸면 될 것 같아요
struct BookmarkedConcert: Identifiable {
    var id = UUID()
    var artist: String
    var date: Date
    var tourName: String
    var venue: String
}
