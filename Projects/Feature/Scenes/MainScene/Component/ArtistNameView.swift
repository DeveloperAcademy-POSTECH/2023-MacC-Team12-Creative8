//
//  HorizontalArtistNameScrollView.swift
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

struct ArtistNameView: View {
  @Binding var selectedTab: Tab
  
    var body: some View {
      HStack(spacing: 0) {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
              .font(.title)
              .bold()
              .padding(.trailing, 40)
      }
    }
}

#Preview {
  ArtistNameView(selectedTab: .constant(.home))
}
