//
//  NetworkUnavailableView.swift
//  Feature
//
//  Created by 장수민 on 2/26/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import Foundation

struct NetworkUnavailableView: View {
  @Environment(NetworkMonitor.self) private var networkMonitor

    var body: some View {
      ContentUnavailableView {
          Label("네트워크에 연결되어 있지 않습니다", systemImage: "wifi.exclamationmark")
          .foregroundStyle(Color.mainBlack)
      } description: {
          Text("인터넷 연결을 확인한 뒤 다시 시도해 주세요")
          .foregroundStyle(Color.mainBlack)
      } actions: {
        Button {
          networkMonitor.startMonitoring()
        } label: {
          Text("새로고침")
            .bold()
            .foregroundStyle(Color.mainWhite)
            .font(.system(size: 14))
            .padding(EdgeInsets(top: 17, leading: 22, bottom: 17, trailing: 22))
            .background(RoundedRectangle(cornerRadius: 14)
              .foregroundStyle(Color.buttonBlack))
        }
      }
      .background(Color.backgroundWhite)
    }
}

#Preview {
    NetworkUnavailableView()
}
