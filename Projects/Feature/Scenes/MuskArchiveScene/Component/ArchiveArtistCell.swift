//
//  ArchiveArtistCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import UI

struct ArchiveArtistCell: View {
  let artistUrl: URL
  let isNewUpdate: Bool
    var body: some View {
      AsyncImage(url: artistUrl) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
          .overlay {
            if isNewUpdate {
//                Circle()
//                  .foregroundStyle(.blue)
//                  .padding()
//                  .background {
//                    Circle()
//                      .foregroundStyle(.white)
//                  }

            }
          }
      } placeholder: {
        ProgressView()
      }
    }
}

#Preview {
  ArchiveArtistCell(artistUrl: URL(string: "https://newsimg.sedaily.com/2019/10/11/1VPHATB1H9_1.jpg")!, isNewUpdate: true)
}

