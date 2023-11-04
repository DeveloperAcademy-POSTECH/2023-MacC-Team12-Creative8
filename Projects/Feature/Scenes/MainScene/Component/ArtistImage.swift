//
//  ArtistImage.swift
//  Feature
//
//  Created by 장수민 on 11/4/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI

struct ArtistImage: View {
  var imageUrl: String
    var body: some View {
      AsyncImage(url: URL(string: imageUrl)) { image in
        image
          .resizable()
          .scaledToFill()
          .frame(width: UIWidth * 0.78, height: UIWidth * 0.78)
          .overlay {
            MainView().artistImageOverlayButton
          }
          .clipShape(RoundedRectangle(cornerRadius: 15))
              .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.mainGrey1, lineWidth: 1))
      } placeholder: {
        ProgressView()
      }
    }
}

#Preview {
    ArtistImage(imageUrl: "https://images-prod.dazeddigital.com/1428/azure/dazed-prod/1320/4/1324149.jpeg")
}
