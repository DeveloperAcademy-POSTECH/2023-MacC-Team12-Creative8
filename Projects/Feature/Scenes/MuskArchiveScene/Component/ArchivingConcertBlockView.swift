//
//  ArchivingConcertBlockView.swift
//  Feature
//
//  Created by A_Mcflurry on 10/15/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct ArchivingConcertBlockView: View {
// 실제 코드
//  let concertInfo: [ArchivedConcertInfo]
  // 임시 코드
  var concertInfo: [ArchivedConcertInfo] = []
  var years: [Int] = []
  var concertCellInfo: [(Int, Int)] = []
  var maxminCnt: (Int, Int) = (0, 0)
  init() {
    concertInfo = generateArchivedConcertInfoArray()
    concertCellInfo = extractYearsAndCountsFromConcerts(concertInfo)
    maxminCnt = (concertCellInfo.reduce(Int.min) { max($0, $1.1) },
                  concertCellInfo.reduce(Int.max) { min($0, $1.1) })
  }
  // \임시 코드
  var body: some View {
    GeometryReader { geo in
      VStack(alignment: .leading, spacing: 0) {
        ForEach(0..<concertCellInfo.count, id: \.self) { index in
          ArchiveYearCell(year: concertCellInfo[index].0, concertCnt: concertCellInfo[index].1)
            .frame(width: cellWidthSize(concertCellInfo[index].1, maxminCnt, geo.size.width), height: 131)
        }
      }
    }
  }

  func extractYearsAndCountsFromConcerts(_ concerts: [ArchivedConcertInfo]) -> [(Int, Int)] {
    let calendar = Calendar.current
    let orderedSet = NSOrderedSet(array: concerts.map { calendar.component(.year, from: $0.concertDate) })
    var yearsToCount: [Int] = []
    if let yearArray = orderedSet.array as? [Int] {
      yearsToCount = yearArray.sorted(by: >)
    } else { return [] }
      var yearCounts: [(Int, Int)] = []
      for yearToCount in yearsToCount {
          let concertCount = concerts.filter { calendar.component(.year, from: $0.concertDate) == yearToCount }.count
          yearCounts.append((yearToCount, concertCount))
      }
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

#Preview {
  ArchivingConcertBlockView()
}
