//
//  BlockAllConcertView.swift
//  Feature
//
//  Created by A_Mcflurry on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData

struct BlockAllConcertView: View {
  @Binding var selecteYear: Int
  @Binding var concertCellInfo: [(Int, Int)]
  @Binding var maxminCnt: (Int, Int)
  @Query var concertInfo: [ArchivedConcertInfo]
  var body: some View {
    VStack {
      ForEach(concertInfo.filter { Calendar.current.component(.year, from: $0.concertDate) == selecteYear }) { info in
          Text("\(info.concertTitle)")
      }
    }
    .toolbar {
      ToolbarItem(placement: .principal) {
        HStack(spacing: 0) {
          Text(String(selecteYear))
            .fontWeight(.semibold)
          Menu {
            ForEach(0..<concertCellInfo.count, id: \.self) { index in
              Button(String(concertCellInfo[index].0)) { selecteYear = concertCellInfo[index].0 }
            }
          } label: {
            Image(systemName: "chevron.down")
              .foregroundStyle(.black)
          }
        }
      }
    }
    .onAppear {
      loadInfo(concertInfo: .constant(concertInfo), concertCellInfo: $concertCellInfo, maxminCnt: $maxminCnt)
    }
    .onChange(of: self.concertInfo, { _, newValue in
      loadInfo(concertInfo: .constant(newValue), concertCellInfo: $concertCellInfo, maxminCnt: $maxminCnt)
    })
  }
}
