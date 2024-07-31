//
//  BottomModalView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI
import UIKit

struct BottomModalView: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @ObservedObject var exportViewModel: ExportPlaylistViewModel
  @ObservedObject var vm: SetlistViewModel
  @Binding var showToastMessageAppleMusic: Bool
  @Binding var showToastMessageCapture: Bool
  @State var isSharePresented = false
  
  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      Button {
        exportViewModel.handleAppleMusicButtonAction()
        vm.showModal.toggle()
      } label: {
        HStack {
          Text("Apple Music으로 내보내기")
            .font(.subheadline)
            .foregroundStyle(Color.toastBurn)
          Spacer()
          Image("appleMusic", bundle: setaBundle)
            .resizable()
            .scaledToFit()
            .frame(width: UIWidth * 0.1)
        }
      }
      .padding(.horizontal, UIWidth * 0.04)
      .padding(.vertical)
      .background(RoundedRectangle(cornerRadius: 14)
        .foregroundStyle(Color.mainGrey1))
      // 애플뮤직 권한 허용 거부 상태인 경우
      .alert(isPresented: $exportViewModel.showMusicSettingsAlert) {
        Alert(
          title: Text(""),
          message: Text("플레이리스트 내보내기 기능을 사용하려면 ‘Apple Music' 접근 권한을 허용해야 합니다."),
          primaryButton: .default(Text("취소")),
          secondaryButton: .default(Text("설정").bold(), action: {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
          }))
      }
      Spacer()
      listRowView(
        title: "플레이리스트용 캡쳐하기",
        topDescription: "Bugs, FLO, genie, VIBE의 유저이신가요?", bottomDescription: "OCR 서비스를 사용해 캡쳐만으로 플레이리스트를 만들어보세요.",
        action: {
          exportViewModel.handlePhotoExportButtonAction()
          if !exportViewModel.checkPhotoPermission() {
            takeSetlistToImage(vm.setlistSongKoreanName)
            vm.showModal.toggle()
          }
        }
      )
      // 사진 권한 허용 거부 상태인 경우
      .alert(isPresented: $exportViewModel.showLibrarySettingsAlert) {
        Alert(
          title: Text(""),
          message: Text("사진 기능을 사용하려면 ‘사진/비디오' 접근 권한을 허용해야 합니다."),
          primaryButton: .default(Text("취소")),
          secondaryButton: .default(Text("설정").bold(), action: {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
          }))
      }
      Spacer()
      listRowView(title: "공유하기", topDescription: nil, bottomDescription: nil) {
        self.isSharePresented = true
      }
      .sheet(isPresented: $isSharePresented, content: {
        SetlistImageShareView(artistInfo: artistInfo, setlist: setlist, viewModel: vm, isSharePresented: $isSharePresented)
      })
      
      Spacer()
    }
    .padding(.horizontal)
    .background(Color.settingTextBoxWhite)
  }
  
  private func listRowView(title: LocalizedStringResource, topDescription: LocalizedStringResource?, bottomDescription: LocalizedStringResource?, action: @escaping () -> Void) -> some View {
    Button {
      action()
    } label: {
      HStack {
        VStack(alignment: .leading, spacing: 0) {
          Text(title)
            .font(.subheadline)
            .foregroundStyle(Color.toastBurn)
          VStack(alignment: .leading, spacing: 3) {
            if let topDescription = topDescription {
              Text(topDescription)
                .font(.caption)
                .foregroundStyle(Color.fontGrey2)
                .padding(.top, UIWidth * 0.04)
            }
            if let bottomDescription = bottomDescription {
              Text(bottomDescription)
                .font(.caption)
                .foregroundStyle(Color.fontGrey2)
                .multilineTextAlignment(.leading)
            }
          }
        }
        Spacer()
      }
      .padding(.horizontal, UIWidth * 0.04)
      .padding(.vertical)
      .background(RoundedRectangle(cornerRadius: 14)
        .foregroundStyle(Color.mainGrey1))
    }
  }
  
  private func platformButtonView(title: String, image: String, action: @escaping () -> Void) -> some View {
    Button {
      action()
    } label: {
      VStack(spacing: 0) {
        ZStack {
          RoundedRectangle(cornerRadius: 14)
            .foregroundStyle(Color.mainGrey1)
            .frame(maxWidth: .infinity)
            .frame(height: UIWidth * 0.2)
          
          Image(image, bundle: setaBundle)
            .resizable()
            .scaledToFit()
            .frame(width: UIWidth * 0.1)
          
        }
        .padding(.bottom, 11)
        
        Text(title)
          .font(.caption2)
          .foregroundStyle(Color.toastBurn)
      }
    }
  }
}
