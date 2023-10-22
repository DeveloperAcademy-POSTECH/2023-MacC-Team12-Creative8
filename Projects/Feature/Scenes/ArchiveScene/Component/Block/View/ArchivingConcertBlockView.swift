//
//  ArchivingConcertBlockView.swift
//  Feature
//
//  Created by A_Mcflurry on 10/15/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData
import Core

struct ArchivingConcertBlockView: View {
  @Query var concertInfo: [ArchivedConcertInfo]
  @StateObject var viewModel = ArchiveBlcokViewModel()
  var body: some View {
    GeometryReader { geo in
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          ForEach(0..<viewModel.concertCellInfo.count, id: \.self) { index in
            NavigationLink {
              BlockAllConcertView(selecteYear: $viewModel.selecteYear,
                                  concertCellInfo: $viewModel.concertCellInfo,
                                  maxminCnt: $viewModel.maxminCnt)
            } label: {
              ArchiveYearCell(year: viewModel.concertCellInfo[index].0,
                              concertCnt: viewModel.concertCellInfo[index].1)
                .frame(width: cellWidthSize(viewModel.concertCellInfo[index].1,
                                            viewModel.maxminCnt, geo.size.width), height: 131)
            }
            .simultaneousGesture(TapGesture().onEnded {
              viewModel.selecteYear = viewModel.concertCellInfo[index].0
            })

          }
        }
      }
    }
    .onAppear {
      loadInfo(concertInfo: .constant(concertInfo),
               concertCellInfo: $viewModel.concertCellInfo,
               maxminCnt: $viewModel.maxminCnt)
    }
    .onChange(of: self.concertInfo, { _, newValue in
      loadInfo(concertInfo: .constant(newValue),
               concertCellInfo: $viewModel.concertCellInfo,
               maxminCnt: $viewModel.maxminCnt)
    })
  }
}

#Preview {
  ArchivingConcertBlockView()
}

// Core는 import가 안되고,,, UI에 넣자니ArchivedConcertInfo 얘를 Feature에서 찾아야 하는데, UI에서 Feature가 import되지 않는군요.
// 나중에 Core에 Model을 넣고, 이걸 UI Extension으로 옮길 예정입니다.
public extension View {
  func loadInfo(concertInfo: Binding<[ArchivedConcertInfo]>,
                concertCellInfo: Binding<[(Int, Int)]>,
                maxminCnt: Binding<(Int, Int)>) {
    concertCellInfo.wrappedValue = extractYearsAndCountsFromConcerts(concertInfo.wrappedValue)
    maxminCnt.wrappedValue = (concertCellInfo.wrappedValue.reduce(Int.min) { max($0, $1.1) },
                  concertCellInfo.wrappedValue.reduce(Int.max) { min($0, $1.1) })
  }

  func extractYearsAndCountsFromConcerts(_ concerts: [ArchivedConcertInfo]) -> [(Int, Int)] {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"

    var yearToCountDictionary: [Int: Int] = [:]
    for concert in concerts {
      let dateString = concert.setlist.date
      if let date = dateFormatter.date(from: dateString) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)

        if let count = yearToCountDictionary[year] {
          yearToCountDictionary[year] = count + 1
        } else {
          yearToCountDictionary[year] = 1
        }
      }
    }

    let sortedYearCounts = yearToCountDictionary.sorted { $0.key > $1.key }
    let yearCounts = sortedYearCounts.map { (year: $0.key, count: $0.value) }

    return yearCounts
  }

  func cellWidthSize(_ itemCount: Int, _ maxminCnt: (Int, Int), _ geoSize: CGFloat) -> CGFloat {
    switch itemCount {
    case maxminCnt.0: return geoSize
    case maxminCnt.1: return geoSize/2
    default:
      let halfGeoSize = geoSize / 2
      let itemCountFraction = CGFloat(itemCount) / CGFloat(maxminCnt.0)
      let result = halfGeoSize + (halfGeoSize * itemCountFraction)
      return result
    }
  }
}
