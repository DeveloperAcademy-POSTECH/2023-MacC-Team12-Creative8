//
//  ShareOptionButtonView.swift
//  Feature
//
//  Created by 예슬 on 6/10/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI

struct ShareOptionButtonView: View {
  let action: () -> Void
  let label: String
  let systemImageName: String
  
  var body: some View {
    Button(action: {
      action()
    }, label: {
      HStack {
        Text(label)
        Spacer()
        Image(systemName: systemImageName)
      }
      .foregroundStyle(.black)
    })
    .padding(.vertical, 8)
  }
}

struct ButtonInfo: Identifiable {
  let id = UUID()
  let action: () -> Void
  let label: String
  let systemImageName: String
}
