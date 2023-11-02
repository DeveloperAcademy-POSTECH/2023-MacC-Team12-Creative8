//
//  ArchiveArtistCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

struct ArchiveArtistCell: View {
  let artistUrl: URL
  let isNewUpdate: Bool
  var body: some View {
      AsyncImage(url: artistUrl) { image in
        image
          .centerCropped()
          .aspectRatio(1.0, contentMode: .fit)
          .clipShape(RoundedRectangle(cornerRadius: 20))
          .overlay(
                  RoundedRectangle(cornerRadius: 20)
                      .stroke(Color.gray, lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
              )
      } placeholder: {
        ProgressView()
      }
      .frameForCell()
  }
}

#Preview {
  ArchiveArtistCell(artistUrl: URL(string: "https://newsimg.sedaily.com/2019/10/11/1VPHATB1H9_1.jpg")!,
                    isNewUpdate: true)
}
