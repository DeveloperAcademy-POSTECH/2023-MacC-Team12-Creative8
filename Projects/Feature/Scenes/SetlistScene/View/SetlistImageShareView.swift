//
//  SetlistImageShareView.swift
//  Feature
//
//  Created by 예슬 on 5/12/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core

struct SetlistImageShareView: View {
  let artistInfo: ArtistInfo?
  let setlist: Setlist?
  @StateObject var viewModel: SetlistViewModel
  @State private var isPresented = false
  @State private var showToastMessage = false
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.black.ignoresSafeArea()
      ScrollView {
        ZStack {
          VStack {
            let image = shareSetlistToImage(viewModel.setlistSongKoreanName, artistInfo?.name ?? "", setlist)
            Image(uiImage: image)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: UIWidth * 0.72, height: UIHeight * 0.58)
              .padding(.vertical, 28)
            
            VStack(spacing: 0) {
              ShareOptionButtonView(action: { backgroundImage(backgroundImage: image) }, label: "인스타그램 스토리", systemImageName: "star")
              CustomDivider()
              ShareOptionButtonView(action: {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                showToastMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                  showToastMessage = false
                }
              }, label: "이미지 저장", systemImageName: "square.and.arrow.down")
              CustomDivider()
              ShareOptionButtonView(action: { self.isPresented = true }, label: "옵션 더보기", systemImageName: "ellipsis")
                .sheet(isPresented: $isPresented) {
                  ActivityViewController(activityItems: [image])
                }
            }
            .background(.white)
            .cornerRadius(12)
            .padding(.horizontal, 24)
          }
          // TODO: - 이미지 저장 토스트메시지 띄우기
          if showToastMessage {
            
          }
        }
      }
    }
    .navigationTitle("공유하기")
  }
  
  func backgroundImage(backgroundImage: UIImage) {
    if let urlScheme = URL(string: "instagram-stories://share") {
      if UIApplication.shared.canOpenURL(urlScheme) {
        let pasteboardItems = [["com.instagram.sharedSticker.backgroundImage": backgroundImage.pngData()]]
        
        let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]
        
        UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
        
        if let shareURL = URL(string: "instagram-stories://share?source_application=" +
                              "807909384825071") {
          UIApplication.shared.open(shareURL, options: [:], completionHandler: nil)
        }
      } else {
        print("인스타 앱이 깔려있지 않습니다.")
      }
    }
  }
  
  struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
      let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
      print("activityItems \(activityItems)")
      controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
        self.presentationMode.wrappedValue.dismiss()
      }
      
      controller.excludedActivityTypes = []
      return controller
    }
    
    func updateUIViewController (_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
  }
}
