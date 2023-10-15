//
//  ArchivingView.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct ArchivingView: View {
  let concertInfo: [ArchivedConcertInfo] = generateArchivedConcertInfoArray()
  var body: some View {
    VStack {
      archivingArtistView
      ArchivingConcertBlockView()
    }
    .padding()
  }

  private var archivingArtistView: some View {
    ScrollView(.horizontal) {
      Text("Hello")
    }
  }
}

#Preview {
  ArchivingView()
}

// 프리뷰를 위한 더미들. 나중에 합치고 밑에 싹 지우면 됩니다.
  func generateArchivedConcertInfoArray() -> [ArchivedConcertInfo] {
      var concertInfoArray: [ArchivedConcertInfo] = []

      // Get the current date
      let currentDate = Date()

      // Create DateComponents to represent 1 year, 2 years, and 3 years ago
      let oneYearAgoComponents = DateComponents(year: -1)
      let twoYearsAgoComponents = DateComponents(year: -2)
      let threeYearsAgoComponents = DateComponents(year: -3)
      let fiveYearsAgoComponents = DateComponents(year: -5)

      // Create Calendar instance
      let calendar = Calendar.current

      // Generate ArchivedConcertInfo instances for each year
    for _ in 1...20 {
        let archivedConcertInfo = ArchivedConcertInfo(
            concertTitle: "ConcertDummy",
            concertDate: calendar.date(byAdding: fiveYearsAgoComponents, to: currentDate)!,
            singer: "SingerDummy",
            setList: [],
            id: UUID()
        )
        concertInfoArray.append(archivedConcertInfo)
    }

      for _ in 1...15 {
          let archivedConcertInfo = ArchivedConcertInfo(
              concertTitle: "ConcertDummy",
              concertDate: calendar.date(byAdding: threeYearsAgoComponents, to: currentDate)!,
              singer: "SingerDummy",
              setList: [],
              id: UUID()
          )
          concertInfoArray.append(archivedConcertInfo)
      }

      // Generate ArchivedConcertInfo instances for 2 years ago
      for _ in 1...10 {
          let archivedConcertInfo = ArchivedConcertInfo(
              concertTitle: "ConcertDummy",
              concertDate: calendar.date(byAdding: twoYearsAgoComponents, to: currentDate)!,
              singer: "SingerDummy",
              setList: [],
              id: UUID()
          )
          concertInfoArray.append(archivedConcertInfo)
      }

      // Generate ArchivedConcertInfo instances for 1 year ago
      for _ in 1...8 {
          let archivedConcertInfo = ArchivedConcertInfo(
              concertTitle: "ConcertDummy",
              concertDate: calendar.date(byAdding: oneYearAgoComponents, to: currentDate)!,
              singer: "SingerDummy",
              setList: [],
              id: UUID()
          )
          concertInfoArray.append(archivedConcertInfo)
      }

      // Generate the current ArchivedConcertInfo instance
    for _ in 1...4 {
      let archivedConcertInfo = ArchivedConcertInfo(
        concertTitle: "ConcertDummy",
        concertDate: currentDate,
        singer: "SingerDummy",
        setList: [],
        id: UUID()
      )
      concertInfoArray.append(archivedConcertInfo)
    }
      return concertInfoArray
  }
struct ArchivedConcertInfo: Identifiable {
  var concertTitle: String
  var concertDate: Date
  var singer: String
  var setList: [String]
  var id = UUID()
}
