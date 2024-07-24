//
//  EmptyArtistImage.swift
//  Feature
//
//  Created by 장수민 on 7/24/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI

struct EmptyArtistImage: View {
    let foregroundColor: Color
    let backgroundColor: Color
    var body: some View {
      // TODO: 컬러 수정
      HStack(spacing: 0) {
        Rectangle()
          .foregroundStyle(foregroundColor)
        
        Rectangle()
          .foregroundStyle(foregroundColor)
          .cornerRadius(40, corners: [.topLeft])
      }
      .background(backgroundColor)
    }
}

#Preview {
  EmptyArtistImage(foregroundColor: Color.orange, backgroundColor: Color.yellow)
}
