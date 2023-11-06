//
//  BottomView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI

struct BottomView: View {
  var body: some View {
    VStack {
      Text("세트리스트 정보 수정을 원하시나요?")
        .font(.headline)
        .foregroundStyle(Color.mainBlack)
        .padding(.top, 50)
        .padding(.bottom, 30)
      
      VStack {
        Text("잘못된 세트리스트 정보를 발견하셨다면,")
        HStack(spacing: 0) {
          if let url = URL(string: "https://www.setlist.fm") {
            Link(destination: url) {
              Text("Setlist.fm")
                .underline()
            }
          }
          Text("에서 수정할 수 있습니다")
        }
      }
      .font(.footnote)
      .foregroundStyle(Color.fontGrey2)
      .padding(.bottom, 50)
      
      SetlistFMLinkButtonView()
        .padding(.bottom, 130)
        .padding(.horizontal, 30)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color.mainGrey1)
  }
}

#Preview {
  BottomView()
}
