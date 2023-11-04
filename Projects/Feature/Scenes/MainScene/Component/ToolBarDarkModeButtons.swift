//
//  ToolBarDarkModeButtons.swift
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

struct ToolBarDarkModeButtons: View {
  @AppStorage("appearance")
  var appearnace: ButtonType = .automatic
  
  @StateObject var viewModel: MainViewModel
  
    var body: some View {
      ZStack(alignment: .center) {
        RoundedRectangle(cornerRadius: 36)
          .foregroundStyle(Color.mainGrey1)
          .frame(width: UIWidth * 0.45, height: UIWidth * 0.09)
          .padding(.bottom)
        VStack {
          HStack(spacing: UIWidth * 0.07) {
            ForEach(ButtonType.allCases) { mode in
              DarkModeButton(buttonType: mode, viewModel: viewModel)
                .tag(mode)
                .foregroundStyle(mode == appearnace ?  Color.mainBlack: Color.fontGrey3)
            }
          }
        }
      }
    }
}
