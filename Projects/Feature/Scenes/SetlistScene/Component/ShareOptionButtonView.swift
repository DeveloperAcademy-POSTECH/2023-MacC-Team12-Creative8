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
          .font(.callout)
          .fontWeight(.semibold)
        Spacer()
        Image(systemName: systemImageName)
      }
      .foregroundStyle(.black)
    })
    .padding(EdgeInsets(top: 19, leading: 20, bottom: 19, trailing: 16))
  }
}

struct CustomDivider: View {
  var body: some View {
    Rectangle()
      .frame(height: 0.33)
      .foregroundColor(.gray)
      .padding(.leading, 20)
  }
}
