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
  @StateObject var viewModel: NewMainViewModel
  var index: Int
  
    var body: some View {
      VStack(spacing: 0) {
        artistImage
        Group {
          commentText
          artistSetlistCell
        }
        .animation(.easeInOut(duration: 0.1))
        .opacity(viewModel.selectedIndex == index ? 1.0 : 0)
      }
      .frame(width: UIWidth * 0.81)
      .id(index)
    }
  
  private var artistImage: some View {
    ArtistImage(selectedTab: $selectedTab, imageUrl: "https://mblogthumb-phinf.pstatic.net/MjAxNzExMDdfMjg5/MDAxNTA5OTk0MzM0MTI0.XpQ9OUJQWRBuecqvCR_pWjkN9BHbuV37WgIYf599x3og.RTorQ_2W7j0lI0J7YTp5GDtrG8_PhegGmDW2uu2s_XIg.JPEG.bgbgrec/02_실리카겔_-_뚝방길.mov_20171107_035202.631.jpg?type=w800")
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
  ArtistsContentView(selectedTab: .constant(.home), 
                     viewModel: NewMainViewModel(),
                     index: 1)
}
