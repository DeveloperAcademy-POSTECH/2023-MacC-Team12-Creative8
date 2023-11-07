//
//  ArtistContentBlock.swift
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

struct ArtistSetlistCell: View {
  @StateObject var viewModel = MainViewModel()
  @State var dataManager = SwiftDataManager()
  
  var dateAndMonth: String
  var year: String
  var city: String
  var country: String
  var firstSong: String
  var setlistId: String
  var artistInfo: ArtistInfo
  
    var body: some View {
          NavigationLink {
            SetlistView(setlistId: setlistId, artistInfo: artistInfo)
          } label: {
            HStack(spacing: 0) {
              VStack(alignment: .center, spacing: 0) {
                Text(year)
                  .foregroundStyle(Color.fontGrey25)
                  .padding(.bottom, 2)
                Text(dateAndMonth)
                  .foregroundStyle(Color.mainBlack)
                  .kerning(-0.5)
              }
              .font(.headline)
              Spacer()
                .frame(width: UIWidth * 0.08)
              VStack(alignment: .leading, spacing: 0) {
                Text(city + ", " + country)
                  .font(.subheadline)
                  .foregroundStyle(Color.mainBlack)
                  .lineLimit(1)
                  .padding(.bottom, 3)
                Text(firstSong)
                  .font(.footnote)
                  .lineLimit(1)
                  .foregroundStyle(Color.fontGrey25)
              }
              .foregroundStyle(Color.mainBlack)
              .font(.system(size: 14))
              Spacer()
            }
            .padding()
          }
    }
}
