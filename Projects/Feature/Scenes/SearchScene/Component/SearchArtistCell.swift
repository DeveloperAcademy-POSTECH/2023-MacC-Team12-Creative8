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
        AsyncImage(url: URL(string: imageURL)) { image in
          image
            .resizable()
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.mainGrey1, lineWidth: 1))
        } placeholder: {
          ProgressView()
        }
      }
 
      Text("\(artistName)")
        .foregroundStyle(Color.mainBlack)
    }
  }
}
