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
  @StateObject var viewModel: NewMainViewModel
  var index: Int
  
    var body: some View {
      HStack(spacing: 0) {
        Text("Hello, World!\n123")
              .id(index)
              .font(.title)
              .bold()
      }
      .onTapGesture {
        withAnimation {
          viewModel.selectedIndex = index
          viewModel.scrollToIndex = index
        }
      }
      .foregroundColor(viewModel.selectedIndex == index ? Color.mainBlack : Color.fontGrey3)
    }
}

#Preview {
  ArtistNameView(selectedTab: .constant(.home), 
                 viewModel: NewMainViewModel(), 
                 index: 1)
}
