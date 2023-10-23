//
//  SampleArchiveMainView.swift
//  Feature
//
//  Created by 장수민 on 10/22/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
// MARK: 임시로 만든 아카이빙 화면입니다 이렇게 보인다 정도만...)
struct SampleArchiveMainView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    @ObservedObject var vieWModel = ConcertListViewModel()
    var body: some View {
      VStack {
        
      }
    }
    private var viewPicker: some View {
        HStack {
            Text("공연 다시 듣기")
                .font(.title3)
                .bold()
            Spacer()
            Picker("Form Selection", selection: $vieWModel.userSelection) {
                ForEach(vieWModel.options, id: \.self) {
                    Image(systemName: $0)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: screenWidth * 0.3)
        }
    }
}

#Preview {
    SampleArchiveMainView()
}
