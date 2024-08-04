//
//  HorizontalArtistNameScrollView.swift
//  Feature
//
//  Created by 장수민 on 11/17/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Marquee

struct ArtistNameView: View {
  @Binding var selectedTab: Tab
  @ObservedObject var viewModel: MainViewModel
  var index: Int
  var name: String
  @State private var textWidth: CGFloat = 0
  @State private var parentWidth: CGFloat = 0
  
  var body: some View {
    HStack(spacing: 0) {
      if textWidth > parentWidth {
        Marquee {
          Text(name)
            .font(.title)
            .fontWeight(.semibold)
            .fixedSize(horizontal: true, vertical: false) 
        }
        .marqueeDuration(5.0)
        .frame(width: parentWidth)
      } else {
        Text(name)
          .font(.title)
          .fontWeight(.semibold)
          .lineLimit(1)
          .frame(width: UIWidth * 0.8, alignment: .center)
      }
    }
    .foregroundColor(viewModel.selectedIndex == index ? Color.mainBlack : Color.gray)
    .background(
      GeometryReader { geo in
        Color.clear
          .onAppear {
            parentWidth = geo.size.width
            measureTextWidth()
          }
      }
    )
  }
  
  private func measureTextWidth() {
    let text = Text(name)
      .font(.title)
      .fontWeight(.semibold)
    
    let controller = UIHostingController(rootView: text)
    controller.view.frame.size = .zero
    controller.view.sizeToFit()
    textWidth = controller.view.intrinsicContentSize.width
  }
}

