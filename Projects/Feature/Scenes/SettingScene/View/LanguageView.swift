//
//  FAQView.swift
//  Feature
//
//  Created by 예슬 on 2023/11/15.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct FAQView: View {
  
  @ObservedObject var viewModel = SettingViewModel()
  
    var body: some View {
      ZStack {
        Color.backgroundGrey
        ScrollView {
          VStack {
            HStack(alignment: .top) {
              Text("Q.")
              Text(viewModel.fiveArtistsMain[0])
            }
            .padding(26)
          }
          .background(Color.settingTextBoxWhite)
          .padding(.vertical, 24)
          .padding(.horizontal, 20)
        }
      }
      .ignoresSafeArea()
    }
}

#Preview {
    FAQView()
}
