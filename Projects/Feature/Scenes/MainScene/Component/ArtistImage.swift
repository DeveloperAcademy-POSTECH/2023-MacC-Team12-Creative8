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
  var imageUrl: String
  
  var body: some View {
    VStack {
      Group {
        if !imageUrl.isEmpty {
          AsyncImage(url: URL(string: imageUrl)) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fill)
              .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.mainGrey1, lineWidth: 1))
          } placeholder: {
            ProgressView()
          }
        } else {
          artistEmptyImage
        }
      }
      .frame(width: UIWidth * 0.81, height: UIWidth * 0.81)
      .clipShape(RoundedRectangle(cornerRadius: 15))
      .clipped()
    }
  }
  
  public var artistEmptyImage: some View {
    RoundedRectangle(cornerRadius: 15)
      .foregroundStyle(Color(UIColor.systemGray))
      .overlay(
        Image("ticket", bundle: setaBundle)
          .resizable()
          .renderingMode(.template)
          .foregroundStyle(Color(UIColor.systemGray))
          .aspectRatio(contentMode: .fit)
          .frame(width: UIWidth * 0.43)
      )
      .frame(width: UIWidth * 0.81, height: UIWidth * 0.81)
  }
}

#Preview {
  ArtistImage(selectedTab: .constant(.home), imageUrl: "https://images-prod.dazeddigital.com/1428/azure/dazed-prod/1320/4/1324149.jpeg")
}
