//
//  ExportPlaylistButtonView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI

struct ExportPlaylistButtonView: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @ObservedObject var vm: SetlistViewModel
  @Binding var showToastMessageAppleMusic: Bool
  @Binding var showToastMessageCapture: Bool
  @Binding var showToastMessageSubscription: Bool
  @ObservedObject var exportViewModel: ExportPlaylistViewModel
  
  private func toastMessageToShow() -> LocalizedStringResource? {
    if showToastMessageAppleMusic {
      return "1~2분 후 Apple Music에서 확인하세요"
    } else if showToastMessageCapture {
      return "캡쳐된 사진을 앨범에서 확인하세요"
    } else if showToastMessageSubscription {
      return "플레이리스트를 내보내려면 Apple Music을 구독해야 합니다"
    } else {
      return nil
    }
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      // TODO: 토스트팝업 메시지랑 아이콘 수정해서 넣어야 함.
//      if let message = toastMessageToShow() {
//        ToastMessageView(message: message)
//      }
      
      Text("애플 뮤직으로 내보내기")
        .foregroundStyle(Color.mainWhite)
        .font(.callout)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.mainBlack)
        .cornerRadius(14)
        .padding(.horizontal, 30)
        .background(Rectangle().foregroundStyle(Color.gray6))
        .onTapGesture {
          vm.createArrayForExportPlaylist(setlist: setlist, songList: artistInfo?.songList ?? [], artistName: artistInfo?.name)
          vm.showModal.toggle()
        }
      
      Text("다른 뮤직앱으로 내보내기")
        .foregroundStyle(Color(UIColor.systemGray))
        .font(.callout)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 30)
        .padding(.top, 16)
        .padding(.bottom, 38)
        .background(Rectangle().foregroundStyle(Color.gray6))
        .onTapGesture {
          // TODO: 다른 뮤직앱으로 내보내기 Action 추가
        }
    }
    .sheet(isPresented: $vm.showModal) {
      BottomModalView(setlist: setlist, artistInfo: artistInfo, exportViewModel: exportViewModel, vm: vm, showToastMessageAppleMusic: $showToastMessageAppleMusic, showToastMessageCapture: $showToastMessageCapture)
        .presentationDetents([.fraction(0.5)])
        .presentationDragIndicator(.visible)
    }
  }
}
