//
//  ArtistImageAndConcertListView.swift
//  Feature
//
//  Created by 장수민 on 11/17/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData
import Core
import UI
import Combine

struct ArtistsContentView: View {
  @Binding var selectedTab: Tab
    var body: some View {
      VStack(spacing: 0) {
        artistImage
        commentText
        artistSetlistCell
      }
    }
  
  private var artistImage: some View {
    ArtistImage(selectedTab: $selectedTab, imageUrl: "https://image.msscdn.net/mfile_s01/cms-files/6385a60227efe0.85848275.jpg?v=20221130142610")
  }
  
  private var commentText: some View {
    HStack(spacing: 0) {
      Text("실리카겔의 최근 공연")
        .font(.caption)
        .foregroundStyle(Color.fontGrey2)
      Spacer()
    }
    .padding(.top)
  }
  
  private var artistSetlistCell: some View {
    let count = 3
    return ForEach(0..<count, id: \.self) { index in
      VStack(alignment: .leading, spacing: 0) {
        ArtistSetlistCellView(selectedTab: $selectedTab)
          .padding(.vertical)
        if index != 2 {
          Divider()
        }
      }
    }
  }
}

#Preview {
  ArtistsContentView(selectedTab: .constant(.home))
}
