//
//  EmptySetlistView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct EmptySetlistView: View {
  var body: some View {
    VStack {
      Text("등록된 세트리스트가 없어요")
        .font(.headline)
        .fontWeight(.semibold)
        .padding(.top, UIHeight * 0.1)
        .padding(.bottom, 5)
      Text("세트리스트를 직접 작성하고 싶으신가요?")
        .multilineTextAlignment(.center)
        .font(.footnote)
        .foregroundStyle(Color(UIColor.systemGray))
      HStack(spacing: 0) {
        Link(destination: URL(string: "https://www.setlist.fm")!) {
          Text("Setlist.fm")
            .underline()
        }
        Text("에서 추가하세요.")
      }
      .foregroundStyle(Color(UIColor.systemGray))
      .font(.footnote)
    }
  }
}

#Preview {
    EmptySetlistView()
}
