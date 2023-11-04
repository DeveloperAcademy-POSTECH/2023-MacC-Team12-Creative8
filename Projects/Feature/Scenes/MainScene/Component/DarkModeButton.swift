//
//  TopButton.swift
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

struct DarkModeButton: View {
  var buttonType: ButtonType
  @StateObject var viewModel: MainViewModel
  @AppStorage("appearance")
  var appearnace: ButtonType = .automatic
  @Environment(\.colorScheme) var colorScheme
  var body: some View {
    Button {
      viewModel.isTapped.toggle()
      appearnace = buttonType
    } label: {
      VStack {
        Image(systemName: buttonType.icon)
          .foregroundStyle(buttonType == appearnace ? Color.mainBlack : Color.fontGrey3)
          .font(.subheadline)
          .padding(6)
        Text(buttonType.name)
          .font(.system(size: 10))
          .foregroundStyle(buttonType == appearnace ? Color.mainBlack : Color.fontGrey2)
      }
    }.tag(buttonType)
  }
}
