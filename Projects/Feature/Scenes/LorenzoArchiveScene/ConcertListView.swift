//
//  ConcertListView.swift
//  Feature
//
//  Created by 장수민 on 10/22/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

struct ConcertListView: View {
  @Query var concert: [ArchivedConcertInfo]
  @StateObject var viewModel = ConcertListViewModel()
  var body: some View {
    VStack {
      ForEach(0..<viewModel.concertYears.count, id: \.self) { yearIndex in
        HStack {
          Text(String(viewModel.concertYears[yearIndex].0))
          Spacer()
          Image(systemName: "arrow.right")
        }
        Divider()

        ForEach(concert.filter { Calendar.current.component(.year, from: $0.setlist.date) == viewModel.concertYears[yearIndex].0 }) { item in
          let formattedDate = viewModel.dateFormatter.string(from: item.setlist.date)
          let dayOfWeek = viewModel.dayOfWeekFormatter.string(from: item.setlist.date)

          HStack {
            VStack {
              Text(formattedDate)
              Text(dayOfWeek)
            }

            Text(item.artistInfo.name)
            Text(item.setlist.title)
            Text(item.setlist.venue)
          }

        }
        Divider()
      }
    }
    .onAppear { viewModel.concertYears = extractYearsAndCountsFromConcerts(concert)
      print(viewModel.concertYears)
    }
  }
}

#Preview {
    ConcertListView()
}


//VStack(spacing: 0) {
//  Divider()
//  ForEach(0..<viewModel.concertYears.count, id: \.self) { index in
//    VStack(spacing: 0) {
//      HStack(spacing: 0) {
//        Text("\(viewModel.concertYears[index].0)")
//          .bold()
//          .padding(.vertical, UIHeight * 0.03)
//        Spacer()
//        // MARK: 연도별 뷰로 연결해주시면 됩니다...
//        NavigationLink(destination: Text("연도별 뷰로 연결해주시믄 됩니다...")) {
//          Image(systemName: "arrow.right")
//            .foregroundStyle(.black)
//        }
//      }
//      Divider()
//      // 연도별 공연
//      ForEach(0 ..< concert.filter {
//        Calendar.current.component(.year, from: $0.setlist.date) ==
//        viewModel.concertYears[index].0 }, id: \.self) { item in
//          // 월.일
//          let formattedDate =
//          viewModel.dateFormatter.string(from: item.setlist.date)
//          // 요일
//          let dayOfWeek =
//          viewModel.dayOfWeekFormatter.string(from: item[item].date)
//          VStack(alignment: .leading, spacing: 0) {
//            // MARK: 세트리스트 뷰로 연결해주시면 됩니다...
//            NavigationLink(destination: ProgressView()) {
//              HStack(spacing: 0) {
//                VStack(spacing: 0) {
//                  Text(formattedDate)
//                    .foregroundStyle(.black)
//                    .font(.callout)
//                    .bold()
//                  Text(dayOfWeek)
//                    .foregroundStyle(.gray)
//                    .font(.callout)
//                }
//                .padding(.trailing)
//                VStack(alignment: .leading, spacing: 0) {
//                  // 아티스트
//                  Text(viewModel.sampleBookmarkedConcerts[concert].artist)
//                    .bold()
//                  // 공연 이름
//                  Text(viewModel.sampleBookmarkedConcerts[concert].tourName)
//                    .bold()
//                  // 장소
//                  Text(viewModel.sampleBookmarkedConcerts[concert].venue)
//                }
//                .foregroundStyle(.black)
//                .font(.system(size: 14))
//                .padding(.leading)
//              }
//            }
//            .padding(.vertical)
//            Divider()
//          }
//        }
//    }
//  }
//  Spacer()
//    .frame(height: UIHeight * 0.14)
//    .padding(.horizontal, 20)
//}
//.onAppear {
//  viewModel.concertYears = extractYearsAndCountsFromConcerts(concert)
//}
