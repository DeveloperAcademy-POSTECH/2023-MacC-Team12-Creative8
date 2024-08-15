//
//  ArchiveArtistCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

struct ArchiveArtistCellImage: View {
  let artistUrl: URL?
  @Environment(\.colorScheme) var colorScheme
  var body: some View {
    Group {
      if let url = artistUrl {
        AsyncImage(url: url) { image in
          image
            .centerCropped()
        } placeholder: {
          ProgressView()
        }
      } else {
        if colorScheme == .light {
          Image(uiImage: UIImage(named: "artistViewTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
            .centerCropped()
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
            )
        } else {
          Image(uiImage: UIImage(named: "darkArtistViewTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
            .centerCropped()
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
            )
        }
      }
    }
    .aspectRatio(1.0, contentMode: .fit)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .frameForCell()
  }
}
