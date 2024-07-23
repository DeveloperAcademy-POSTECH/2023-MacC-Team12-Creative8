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
  @State var isPresented = false
  @Binding var isSharePresented: Bool
  
  var body: some View {
    ZStack(alignment: .top) {
      Color.black.ignoresSafeArea()
      ScrollView {
        VStack {
          HStack {
            Button(action: {
              isSharePresented.toggle()
            }, label: {
              Image(systemName: "xmark")
                .foregroundStyle(.white)
            })
            .padding(.leading, 8)
            .padding(.trailing, 133)
            
            Text("공유하기")
              .font(.headline)
              .foregroundStyle(.white)
            Spacer()
          }
          .padding(.bottom, 27)
          
          let image = shareSetlistToImage(viewModel.setlistSongKoreanName, artistInfo?.name ?? "", setlist)
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: UIWidth * 0.54, height: UIHeight * 0.44)
            .padding(.bottom, 83)
          
          let buttons = [
            ShareOptionButton(action: {
              backgroundImage(backgroundImage: image)
            }, label: "인스타그램 스토리", systemImageName: "star"),
            
            ShareOptionButton(action: {
              UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }, label: "이미지 저장", systemImageName: "square.and.arrow.down"),
            
            ShareOptionButton(action: {
              self.isPresented = true
            }, label: "옵션 더보기", systemImageName: "ellipsis")
          ]
          
          List {
            ForEach(buttons) { button in
              ShareOptionButtonView(action: button.action, label: button.label, systemImageName: button.systemImageName)
                .sheet(isPresented: $isPresented) {
                  if button.label == "옵션 더보기" {
                    ActivityViewController(activityItems: [image])
                  }
                }
                .listRowBackground(Color.white)
            }
          }
          .listStyle(.plain)
          .frame(height: CGFloat(buttons.count) * 59)
          .cornerRadius(16)
          .scrollDisabled(true)
          .padding(.horizontal, 24)
          
          Button(action: {
            isSharePresented.toggle()
          }, label: {
            HStack {
              Text("취소하기")
              Spacer()
              Image(systemName: "xmark")
            }
            .foregroundStyle(.white)
            .padding(EdgeInsets(top: 19, leading: 20, bottom: 19, trailing: 20))
          })
          .background(.white.opacity(0.32))
          .cornerRadius(12)
          .padding(.horizontal, 24)
        }
      }
    }
    .navigationTitle("공유하기")
  }
  
  func backgroundImage(backgroundImage: UIImage) {
    if let urlScheme = URL(string: "instagram-stories://share") {
      if UIApplication.shared.canOpenURL(urlScheme) {
        let pasteboardItems = [["com.instagram.sharedSticker.stickerImage": backgroundImage.pngData(),
                                "com.instagram.sharedSticker.backgroundImage": backgroundImage.pngData()]]
        
        let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]
        
        UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
        
        UIApplication.shared.open(urlScheme as URL, options: [:], completionHandler: nil)
      } else {
        print("인스타 앱이 깔려있지 않습니다.")
      }
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
    
    controller.excludedActivityTypes = []
    return controller
  }
  
  func updateUIViewController(
    _ uiViewController: UIActivityViewController,
    context: UIViewControllerRepresentableContext<ActivityViewController>
  ) {}
}
