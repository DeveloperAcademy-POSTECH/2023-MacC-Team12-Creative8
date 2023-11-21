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
  @StateObject var exportViewModel = ExportPlaylistViewModel()
  @ObservedObject var vm: SetlistViewModel
  @Binding var showToastMessageAppleMusic: Bool
  @Binding var showToastMessageCapture: Bool
  @State var isSharePresented = false
  @State var showSettingsAlert = false
  
  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      HStack {
        Spacer()
        Text("플레이리스트를 내보낼 앱을 선택해주세요")
          .font(.caption)
          .foregroundStyle(Color.toastBurn)
        Spacer()
      }
      .padding(.top)
      Spacer()
      HStack(alignment: .center, spacing: 0) {
        platformButtonView(title: "Apple Music", image: "appleMusic") {
            AppleMusicService().requestMusicAuthorization()
            CheckAppleMusicSubscription.shared.appleMusicSubscription()
            AppleMusicService().addPlayList(name: "\(artistInfo?.name ?? "" ) @ \(setlist?.eventDate ?? "")", musicList: vm.setlistSongName, singer: artistInfo?.name ?? "", venue: setlist?.venue?.name)
            vm.showModal.toggle()
            showToastMessageAppleMusic = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
              showToastMessageAppleMusic = false
            }
        }
        Spacer()
        platformButtonView(title: "Youtube Music", image: "youtubeMusic") {
          //TODO: 유튜브 뮤직 기능 연결
        }
        Spacer()
        platformButtonView(title: "Spotify", image: "spotify") {
          //TODO: 스포티파이 기능 연결
        }
      }
      Spacer()
      listRowView(
        title: "플레이리스트용 캡쳐하기",
        topDescription: "Bugs, FLO, genie, VIBE의 유저이신가요?", bottomDescription: "OCR 서비스를 사용해 캡쳐만으로 플레이리스트를 만들어보세요.",
        action: {
          if exportViewModel.checkPhotoPermission() {
            showSettingsAlert = true
          } else {
          takeSetlistToImage(vm.setlistSongKoreanName, artistInfo?.name ?? "")
          vm.showModal.toggle()
          showToastMessageCapture = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            showToastMessageCapture = false
          }
        }
        }
      )
      Spacer()
      listRowView(title: "공유하기", topDescription: nil, bottomDescription: nil) {
        self.isSharePresented = true
      }
      .sheet(isPresented: $isSharePresented, content: {
         let image = shareSetlistToImage(vm.setlistSongKoreanName, artistInfo?.name ?? "")
         ActivityViewController(activityItems: [image])
      })
      
      Spacer()
    }
    .padding(.horizontal)
    .background(Color.settingTextBoxWhite)
    // 사진 권한 허용 거부 상태인 경우
    .alert(isPresented: $showSettingsAlert) {
         Alert(
          title: Text(""),
                message: Text("사진 기능을 사용하려면 ‘사진/비디오' 접근 권한을 허용해야 합니다."),
               primaryButton: .default(Text("취소")),
               secondaryButton:  .default(Text("설정").bold(), action: {
           UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
       }))
            }

  }
  
  private func listRowView(title: LocalizedStringResource, topDescription: LocalizedStringResource?, bottomDescription: LocalizedStringResource?, action: @escaping () -> Void) -> some View {
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
          }
        }
      }
      Spacer()
    }
    .padding(.horizontal, UIWidth * 0.04)
    .padding(.vertical)
    .background(RoundedRectangle(cornerRadius: 14)
      .foregroundStyle(Color.mainGrey1))
    .onTapGesture {
      action()
    }
  }
  
  private func platformButtonView(title: String, image: String, action: @escaping () -> Void) -> some View {
    VStack(spacing: 0) {
      Image(image, bundle: setaBundle)
        .resizable()
        .scaledToFit()
        .frame(width: UIWidth * 0.1)
        .padding(.vertical)
        .padding(.horizontal, 32)
        .background(RoundedRectangle(cornerRadius: 14)
          .foregroundStyle(Color.mainGrey1)
        )
        .padding(.bottom, 11)
      
      Text(title)
        .font(.caption2)
        .foregroundStyle(Color.toastBurn)
    }
    .onTapGesture {
      action()
    }
  }
}
struct ActivityViewController: UIViewControllerRepresentable {
  var activityItems: [Any]
  var applicationActivities: [UIActivity]? = nil
  @Environment(\.presentationMode) var presentationMode
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>
  ) -> UIActivityViewController {
    let controller = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: applicationActivities
    )
    print("activityItems \(activityItems)")
    controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
      self.presentationMode.wrappedValue.dismiss()
    }
    return controller
  }
  
  func updateUIViewController(
    _ uiViewController: UIActivityViewController,
    context: UIViewControllerRepresentableContext<ActivityViewController>
  ) {}
}
