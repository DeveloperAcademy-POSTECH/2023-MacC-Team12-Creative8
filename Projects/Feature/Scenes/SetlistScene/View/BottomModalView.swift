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
  let image = UIImage(systemName: "star")
  @ObservedObject var vm: SetlistViewModel
  @Binding var showToastMessageAppleMusic: Bool
  @Binding var showToastMessageCapture: Bool
  @State var isSharePresented = false
  
  var body: some View {
    VStack(alignment: .leading) {
      Spacer()
      
      listRowView(title: "Apple Music에 옮기기", description: nil, action: {
        AppleMusicService().requestMusicAuthorization()
        CheckAppleMusicSubscription.shared.appleMusicSubscription()
        AppleMusicService().addPlayList(name: "\(artistInfo?.name ?? "" ) @ \(setlist?.eventDate ?? "")", musicList: vm.setlistSongName, singer: artistInfo?.name ?? "", venue: setlist?.venue?.name)
        vm.showModal.toggle()
        showToastMessageAppleMusic = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          showToastMessageAppleMusic = false
        }
      })
      
      Spacer()
      
      listRowView(
        title: "세트리스트 캡처하기",
        description: "Bugs, FLO, genie, VIBE의 유저이신가요? OCR 서비스를\n사용해 캡쳐만으로 플레이리스트를 만들어 보세요.",
        action: {
          takeSetlistToImage(vm.setlistSongKoreanName, artistInfo?.name ?? "")
          vm.showModal.toggle()
          showToastMessageCapture = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            showToastMessageCapture = false
          }
        }
      )
      
      Spacer()
      
      // 공유하기
      Button {
        self.isSharePresented = true
      } label: {
        Text("공유하기")
      }
      .sheet(isPresented: $isSharePresented, content: {
         let image = shareSetlistToImage(vm.setlistSongKoreanName, artistInfo?.name ?? "")
         ActivityViewController(activityItems: [image])
      })
    }
    .padding(.horizontal, 30)
    .background(Color.settingTextBoxWhite)
  }
  
  private func listRowView(title: String, description: String?, action: @escaping () -> Void) -> some View {
    HStack {
      VStack(alignment: .leading, spacing: UIHeight * 0.01) {
        Text(title)
          .font(.headline)
          .foregroundStyle(Color.mainBlack)
        if let description = description {
          Text(description)
            .font(.caption)
            .foregroundStyle(Color.fontGrey2)
        }
      }
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundStyle(Color.mainBlack)
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
