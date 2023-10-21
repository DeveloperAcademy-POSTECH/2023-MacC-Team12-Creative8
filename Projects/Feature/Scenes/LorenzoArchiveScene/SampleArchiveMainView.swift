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
        ScrollView {
            VStack(spacing: 0) {
                // MARK: viewPicker: 뷰 고르는 버튼입니다 이거 가져가시면 됩니당
                viewPicker
                    .padding(.horizontal, 20)
                    .padding(.bottom, screenHeight * 0.05)
                if vieWModel.userSelection == vieWModel.options[1] {
                    EmptyView()
                } else {
                    ConcertListView()
                }
            }
        }
    }
    var viewPicker: some View {
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
