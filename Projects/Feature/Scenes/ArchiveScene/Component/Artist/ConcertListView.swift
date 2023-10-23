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
  @StateObject var viewModel = ArchiveViewModel()
  @State var selectYear: Int = 0
  var body: some View {
    VStack {
      Divider()
        .foregroundStyle(Color.lineGrey1)
      ForEach(0..<viewModel.concertCellInfo.count, id: \.self) { yearIndex in
        NavigationLink {
          BlockAllConcertView(selecteYear: $selectYear, concertCellInfo: $viewModel.concertCellInfo, maxminCnt: $viewModel.maxminCnt)
        } label: {
          HStack {
            Text(String(viewModel.concertCellInfo[yearIndex].0)).foregroundStyle(Color.fontBlack)
            Spacer()
            Image(systemName: "arrow.right").foregroundStyle(Color.mainBlack)
          }
          .bold()
          .padding()
        }
        .simultaneousGesture(TapGesture().onEnded {
          selectYear = viewModel.concertCellInfo[yearIndex].0
        })
        Divider()
          .foregroundStyle(Color.lineGrey1)

        ForEach(concert.filter { Calendar.current.component(.year, from: $0.setlist.date) == viewModel.concertCellInfo[yearIndex].0 }) { item in
        ArtistSetlistCell(info: item, isDetail: false)
          Divider()
            .foregroundStyle(Color.lineGrey1)
        }

      }
    }
    .onAppear { viewModel.concertCellInfo = extractYearsAndCountsFromConcerts(concert) }
    .onAppear {
      loadInfo(concertInfo: .constant(concert),
               concertCellInfo: $viewModel.concertCellInfo,
               maxminCnt: $viewModel.maxminCnt)
    }
    .onChange(of: self.concert, { _, newValue in
      loadInfo(concertInfo: .constant(newValue),
               concertCellInfo: $viewModel.concertCellInfo,
               maxminCnt: $viewModel.maxminCnt)
    })
  }
}

#Preview {
    ConcertListView()
}
