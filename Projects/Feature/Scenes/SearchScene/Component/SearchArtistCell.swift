//
//  SearchArtistCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/8/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

struct SearchArtistCell: View {
  @Binding var selectedTab: Tab
  let imageURL: String
  let artistName: String
  let artistMbid: String

  var body: some View {
    VStack(alignment: .leading) {
      NavigationLink {
        ArtistView(selectedTab: $selectedTab, artistName: artistName, artistAlias: "", artistMbid: artistMbid)
      }label: {
        AsyncImage(url: URL(string: imageURL)) { phase in
          switch phase {
          case .empty:
            Image("ticket", bundle: setaBundle)
              .resizable()
              .scaledToFill()
          case .success(let image):
            image
              .resizable()
              .scaledToFill()
          case .failure:
            Image("ticket", bundle: setaBundle)
              .resizable()
              .scaledToFill()
          @unknown default:
            EmptyView()
          }
        }
      }
      .aspectRatio(contentMode: .fit)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.lineGrey1, lineWidth: 1))

      Text("\(artistName)")
        .foregroundStyle(Color.mainBlack)
        .font(.footnote)
        .lineLimit(1)
    }
  }
}
