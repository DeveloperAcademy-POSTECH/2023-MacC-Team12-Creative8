//
//  SearchArtistList.swift
//  Feature
//
//  Created by 고혜지 on 10/23/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI

struct SearchArtistList: View {
  @ObservedObject var viewModel: SearchViewModel
  
  var body: some View {
    if viewModel.isLoading {
      ProgressView()
    } else {
      ForEach(viewModel.artistList, id: \.name) { artist in
        let namePair: (String, String?) = viewModel.koreanConverter.findKoreanName(artist: artist)
        let info: String = ((namePair.1 != nil) ? namePair.1! + ", " : "") + (artist.area?.name ?? "")
        
        ScrollView {
          NavigationLink {
            ArtistView(artistName: namePair.0, artistAlias: namePair.1, artistMbid: artist.id ?? "")
          } label: {
            ListRow(namePair: namePair, info: info)
          }
        }
      }
    }
  }
}

private struct ListRow: View {
  let namePair: (String, String?)
  let info: String
  
  var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading) {
        Text(namePair.0)
          .font(.system(size: 16))
          .foregroundStyle(Color.black)
        if info == "" {
          Text(" ")
            .font(.system(size: 13))
        } else {
          Text(info)
            .font(.system(size: 13))
            .foregroundStyle(Color.gray)
        }
      }
      .padding(.horizontal)
      .padding(.vertical, 5)
      Divider()
        .padding(.horizontal)
    }
  }
}
