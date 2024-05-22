//
//  ArtistSetCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/31/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct ArtistSetCell: View {
  //	 let artistUrl: URL?
  let name: String
  let artistImgUrl: String?
  let isSelected: Bool
  var body: some View {
    HStack {
      Text(name)
        .foregroundStyle(isSelected ? Color.settingTextBoxWhite : Color.fontGrey2)
        .padding(10)
        .font(.subheadline)
      if let url = artistImgUrl {
        AsyncImage(url: URL(string: artistImgUrl!)) { image in
          image
            .centerCropped()
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.mainGrey1, lineWidth: 1)
                .foregroundStyle(Color.clear)
            )
        } placeholder: {
          ProgressView()
        }
      }
    }
    .background {
      let color = isSelected ? Color.mainBlack : Color.mainGrey1
      color.clipShape(RoundedRectangle(cornerRadius: 12))
    }
  }
}

struct AllArtistsSetCell: View {
  let name: LocalizedStringResource
  let isSelected: Bool
  var body: some View {
    Text(name)
      .foregroundStyle(isSelected ? Color.settingTextBoxWhite : Color.fontGrey2)
      .padding(10)
      .background {
        let color = isSelected ? Color.mainBlack : Color.mainGrey1
        color.clipShape(RoundedRectangle(cornerRadius: 12))
      }
  }
}
//
// #Preview {
//		ArtistSetCell(name: "방탄소년단", isSelected: false)
// }
