//
//  ToastMessageView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct ToastMessageView: View {
  let message: LocalizedStringResource
  let subMessage: LocalizedStringResource?
  let icon: String
  let color: Color
  
  var body: some View {
     HStack {
       VStack(alignment: .leading) {
         Text(message)
          .foregroundStyle(Color.mainWhite)
          .font(.subheadline)
         if let subMessage = subMessage {
           Text(subMessage)
            .foregroundStyle(Color.toast1)
            .font(.subheadline)
         }
       }
       Spacer()
       Image(systemName: icon)
         .renderingMode(.template)
         .foregroundStyle(color)
     }
     .padding(15)
     .frame(maxWidth: .infinity)
     .background(
       Color.black850
        .cornerRadius(6.0)
     )
  }
}
