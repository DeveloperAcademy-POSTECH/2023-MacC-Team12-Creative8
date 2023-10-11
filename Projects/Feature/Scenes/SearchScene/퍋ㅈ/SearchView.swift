//
//  SearchView.swift
//  Feature
//
//  Created by 최효원 on 10/7/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct SearchScene: View {
  let tempColor: [Color] = [.red, .orange, .green, .blue, .purple, .pink, .cyan, .indigo, .mint]
  var body: some View {
    ScrollView {
      Group {
        domesticArtist
        overseasArtist
      }
      .padding(.horizontal)
    }
  }

  private var domesticArtist: some View {
    LazyVStack(alignment: .leading) {
      Text("국내 아티스트").bold()
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
        ForEach(tempColor, id: \.self) { item in
          SearchArtistCell(tempColor: item, artistName: "Test")
        }
      }
    }
    .padding(.bottom, 60)
  }

  private var overseasArtist: some View {
    LazyVStack(alignment: .leading) {
      Text("해외 아티스트").bold()
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
        ForEach(tempColor, id: \.self) { item in
          SearchArtistCell(tempColor: item, artistName: "Test")
        }
      }
    }
  }

}
