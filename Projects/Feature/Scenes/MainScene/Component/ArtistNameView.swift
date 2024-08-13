//
//  HorizontalArtistNameScrollView.swift
//  Feature
//
//  Created by 장수민 on 11/17/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import MarqueeText

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
                MarqueeText(
                    text: name,
                    font: .systemFont(ofSize: 32, weight: .semibold),
                    leftFade: 16,
                    rightFade: 16,
                    startDelay: 3
                )
                .frame(width: parentWidth)
            } else {
                Text(name)
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .frame(width: UIWidth * 0.8, alignment: .center)
            }
        }
        .frame(width: UIWidth * 0.8, height: UIHeight * 0.06)
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
