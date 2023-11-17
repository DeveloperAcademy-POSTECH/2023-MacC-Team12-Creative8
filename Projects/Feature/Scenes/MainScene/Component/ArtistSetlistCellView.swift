//
//  ArtistSetlistCellView.swift
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

struct ArtistSetlistCellView: View {
  @Binding var selectedTab: Tab
    var body: some View {
      HStack(spacing:0) {
        VStack {
          Text("2023")
            .foregroundStyle(Color.fontGrey25)
            .tracking(0.5)
          Text("10.13")
            .foregroundStyle(Color.mainBlack)
        }
        .font(.headline)
        .fontWeight(.semibold)
        Spacer()
        VStack(alignment:.leading) {
          Text("Seoul, Korea")
            .font(.footnote)
            .lineLimit(1)
            .foregroundStyle(Color.mainBlack)
          Text("세트리스트 정보가 아직 없습니다")
            .font(.footnote)
            .lineLimit(1)
            .foregroundStyle(Color.fontGrey25)
        }
        
        Spacer()
      }
    }
}

#Preview {
  ArtistSetlistCellView(selectedTab: .constant(.home))
}
