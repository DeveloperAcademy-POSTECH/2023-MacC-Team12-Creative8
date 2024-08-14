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
  let name: String
  let artistImgUrl: URL?
  let isSelected: Bool
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    HStack {
        artistImg
        Text(name)
          .font(.subheadline)
          .fontWeight(isSelected ? .semibold : .regular)
          .foregroundStyle(isSelected ? Color.mainWhite : Color.mainBlack)
          .frame(maxWidth: UIWidth * 0.17)
    }
    .padding(6)
    .background {
      let color = isSelected ? Color.mainBlack : Color.mainWhite
      color.clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .lineLimit(1)
  }
  
  @ViewBuilder
  private var artistImg: some View {
    Group {
      if let url = artistImgUrl {
        AsyncImage(url: url) { image in
          image
            .centerCropped()
//            .overlay(
//              RoundedRectangle(cornerRadius: 8)
////                .stroke(Color.mainGrey1, lineWidth: 1)
//                .foregroundStyle(Color.clear)
//            )
        } placeholder: {
          ProgressView()
        }
      } else {
        if colorScheme == .light {
          Image(uiImage: UIImage(named: "artistViewTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
            .centerCropped()
//            .overlay(
//              RoundedRectangle(cornerRadius: 8)
//                .stroke(Color(UIColor.systemGray), lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정   
//            )
        } else {
          Image(uiImage: UIImage(named: "darkArtistViewTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
            .centerCropped()
//            .overlay(
//              RoundedRectangle(cornerRadius: 8)
//                .stroke(Color(UIColor.systemGray), lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
//            )
        }
      }
    }
    .aspectRatio(1.0, contentMode: .fit)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}

struct AllArtistsSetCell: View {
  let name: LocalizedStringResource
  let isSelected: Bool
  var body: some View {
    Text(name)
      .foregroundStyle(isSelected ? Color.mainWhite : Color.mainBlack)
      .fontWeight(isSelected ? .bold : .regular)
      .padding(10)
      .background {
        let color = isSelected ? Color.mainBlack : Color.mainWhite
        color.clipShape(RoundedRectangle(cornerRadius: 12))
      }
  }
}
//
// #Preview {
//		ArtistSetCell(name: "방탄소년단", isSelected: false)
// }
