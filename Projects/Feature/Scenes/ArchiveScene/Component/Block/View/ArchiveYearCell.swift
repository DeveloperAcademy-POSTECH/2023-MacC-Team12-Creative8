//
//  ArchiveYearCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct ArchiveYearCell: View {
  let year: Int
  let concertCnt: Int
  let blockColor: Color
  var body: some View {
    VStack {
      Text(String(year))
        .foregroundStyle(Color.fontWhite)
        .font(.system(size: 32))
        .bold()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

      Text("\(concertCnt)개 공연 보기")
        .bold()
        .foregroundStyle(Color.fontBlack)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
    .padding()
    .background {
      RoundedRectangle(cornerRadius: 20)
        .foregroundStyle(blockColor)
    }
  }
}

#Preview {
  ArchiveYearCell(year: 2023, concertCnt: 5, blockColor: .blockPink)
    .frame(height: 131)
}
