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
  @StateObject var viewModel = ArchiveViewModel()
  var body: some View {
    VStack(alignment: .leading, spacing: 121) {
      ForEach(0..<viewModel.concertCellInfo.count, id: \.self) { index in
        GeometryReader { geo in
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
        }
        .simultaneousGesture(TapGesture().onEnded {
          viewModel.selecteYear = viewModel.concertCellInfo[index].0
        })
      }
      Spacer()
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

public extension View {
  func loadInfo(concertInfo: Binding<[ArchivedConcertInfo]>,
                concertCellInfo: Binding<[(Int, Int)]>,
                maxminCnt: Binding<(Int, Int)>) {
    concertCellInfo.wrappedValue = extractYearsAndCountsFromConcerts(concertInfo.wrappedValue)
    maxminCnt.wrappedValue = (concertCellInfo.wrappedValue.reduce(Int.min) { max($0, $1.1) },
                  concertCellInfo.wrappedValue.reduce(Int.max) { min($0, $1.1) })
  }

  func extractYearsAndCountsFromConcerts(_ concerts: [ArchivedConcertInfo]) -> [(Int, Int)] {
      var yearToCountDictionary: [Int: Int] = [:]
      for concert in concerts {
          let date = concert.setlist.date
          let calendar = Calendar.current
          let year = calendar.component(.year, from: date)

          if let count = yearToCountDictionary[year] {
              yearToCountDictionary[year] = count + 1
          } else {
              yearToCountDictionary[year] = 1
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

  func dateConverterStringToYear(_ date: String) -> Int? {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd-mm-yyyy"
      if let convertedDate = dateFormatter.date(from: date) {
          let calendar = Calendar.current
          let year = calendar.component(.year, from: convertedDate)
          return year
      }
      return nil
  }
}
