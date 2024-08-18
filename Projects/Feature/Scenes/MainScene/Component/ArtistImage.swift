//
//  ArtistImage.swift
//  Feature
//
//  Created by 장수민 on 11/4/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftData
import Core
import UI
import Combine

struct ArtistImage: View {
  @Binding var selectedTab: Tab
	@Environment(\.colorScheme) var colorScheme
  var imageUrl: String
  
  var body: some View {
    VStack {
      Group {
        if !imageUrl.isEmpty {
          AsyncImage(url: URL(string: imageUrl)) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color(UIColor.systemGray5), lineWidth: 1))
          } placeholder: {
            ProgressView()
          }
        } else {
          artistEmptyImage
        }
      }
      .frame(height: UIHeight * 0.38)
      .clipShape(RoundedRectangle(cornerRadius: 15))
      .clipped()
      .safeAreaPadding(.horizontal, UIWidth * 0.07)
      
    }
  }
  
  public var artistEmptyImage: some View {
    Image("artistViewTicket", bundle: setaBundle)
      .resizable()
      .aspectRatio(contentMode: .fit)
  }
}

#Preview {
  ArtistImage(selectedTab: .constant(.home), imageUrl: "https://images-prod.dazeddigital.com/1428/azure/dazed-prod/1320/4/1324149.jpeg")
}
