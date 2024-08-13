//
//  EmptyMain.swift
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

struct EmptyMainView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        ZStack {
            Color.mainWhite.ignoresSafeArea()
            VStack {
                Spacer()
                Text("찜한 아티스트가 없어요")
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.bottom, 9)
                    .foregroundStyle(Color.mainBlack)
                Group {
                    VStack {
                        Text("검색에서 원하는 아티스트를 찾고")
                        Text("하트버튼을 눌러주세요")
                    }
                    .foregroundStyle(Color.gray)
                }
                .font(.system(size: 13, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(.bottom)
                Spacer()
            }
        }
    }
}
