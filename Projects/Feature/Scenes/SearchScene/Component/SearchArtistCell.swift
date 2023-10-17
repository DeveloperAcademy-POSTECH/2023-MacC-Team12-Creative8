//
//  SearchArtistCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/8/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

struct SearchArtistCell: View {
  let tempColor: Color
//  let imageURL: URL
  let artistName: String

  var body: some View {
    VStack(alignment: .leading) {
      NavigationLink {

      } label: {
        Rectangle().foregroundStyle(tempColor)
  //      AsyncImage(url: imageURL)
      }
        .aspectRatio(contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 20))

      Text("\(artistName)")
    }
  }
}
