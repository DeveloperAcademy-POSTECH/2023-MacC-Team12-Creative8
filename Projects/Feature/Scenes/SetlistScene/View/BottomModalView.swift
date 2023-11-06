//
//  BottomModalView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core

struct BottomModalView: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @ObservedObject var vm: SetlistViewModel
  @Binding var showToastMessage1: Bool
  @Binding var showToastMessage2: Bool
  
  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      
      listView(title: "Apple Music에 옮기기", description: nil, action: {
        AppleMusicService().requestMusicAuthorization()
        CheckAppleMusicSubscription.shared.appleMusicSubscription()
        AppleMusicService().addPlayList(name: "\(artistInfo?.name ?? "" ) @ \(setlist?.eventDate ?? "")", musicList: vm.setlistSongName, singer: artistInfo?.name ?? "", venue: setlist?.venue?.name)
        vm.showModal.toggle()
        showToastMessage1 = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          showToastMessage1 = false
        }
      })
      
      Spacer()
      
      listView(
        title: "세트리스트 캡처하기",
        description: "Bugs, FLO, genie, VIBE의 유저이신가요? OCR 서비스를\n사용해 캡쳐만으로 플레이리스트를 만들어 보세요.",
        action: {
          takeSetlistToImage(vm.setlistSongKoreanName, artistInfo?.name ?? "")
          vm.showModal.toggle()
          showToastMessage2 = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            showToastMessage2 = false
          }
        }
      )
      
      Spacer()
    }
    .padding(.horizontal, 30)
  }
  
  private func listView(title: String, description: String?, action: @escaping () -> Void) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: UIHeight * 0.01) {
        Text(title)
          .font(.system(size: 16, weight: .semibold))
        if let description = description {
          Text(description)
            .font(.system(size: 12, weight: .regular))
            .opacity(0.8)
        }
      }
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundStyle(.gray)
        .onTapGesture {
          action()
        }
    }
  }
}

//#Preview {
//    BottomModalView()
//}
