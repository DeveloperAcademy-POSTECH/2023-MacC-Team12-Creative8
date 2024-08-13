//
//  CustomTitleAlertView.swift
//  Feature
//
//  Created by 장수민 on 11/22/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI
import UIKit

struct CustomTitleAlert: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  let dismissButton: CustomAlertButton?
  let primaryButton: CustomAlertButton?
  @State private var opacity: CGFloat           = 0
  @State private var backgroundOpacity: CGFloat = 0
  @State private var scale: CGFloat             = 1.0
  @State private var text: String = ""
  @ObservedObject var exportViewModel: ExportPlaylistViewModel
  
  var body: some View {
      ZStack(alignment: .center) {
      alertView
    }
    .ignoresSafeArea()
  }
  private var alertView: some View {
    VStack(spacing: 0) {
      titleView
      textFieldView
        .padding(24)
        Divider()
      buttonsView
    }
    .padding(.top, 32)
    .background(Color.mainWhite)
    .cornerRadius(12)
  }
  
  private var titleView: some View {
      Text("플레이리스트 제목")
      .foregroundColor(Color.mainBlack)
      .font(.callout)
      .fontWeight(.bold)
      .multilineTextAlignment(.center)
      .frame(maxWidth: .infinity, alignment: .center)
  }
  
  private var textFieldView: some View {
    TextField("\(artistInfo?.name ?? "" ) @ \(setlist?.eventDate ?? "")",
               text: $text,
              prompt: Text("\(artistInfo?.name ?? "" ) @ \(setlist?.eventDate ?? "")").foregroundColor(Color(UIColor.systemGray3))
    )
    .padding(.horizontal)
    .padding(.vertical, 7)
    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)).stroke(Color(UIColor.systemGray)))
  }
  
  private var buttonsView: some View {
    HStack(spacing: 0) {
      if let dismissButton = dismissButton {
        dismissButtonView
      }
        primaryButtonView
    }
  }
  
  @ViewBuilder
  private var primaryButtonView: some View {
    if let button = primaryButton {
      CustomAlertButton(title: button.title) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
          if !text.isEmpty {
            exportViewModel.playlistTitle = text
          } else {
            exportViewModel.playlistTitle = "\(artistInfo?.name ?? "" ) @ \(setlist?.eventDate ?? "")"
          }
          button.action?()
        }
      }
      .foregroundColor(Color.mainOrange)
    }
  }
  
  @ViewBuilder
  private var dismissButtonView: some View {
    if let button = dismissButton {
      CustomAlertButton(title: button.title) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          button.action?()
        }
      }
      .foregroundColor(Color.mainBlack)
      .background(RoundedRectangle(cornerRadius: 14).foregroundStyle(Color.clear))
    }
  }
  
  private func animate(isShown: Bool, completion: (() -> Void)? = nil) {
    switch isShown {
    case true:
      opacity = 1
      
      withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0).delay(0.5)) {
        backgroundOpacity = 1
        scale             = 1
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        completion?()
      }
      
    case false:
      withAnimation(.easeOut(duration: 0.2)) {
        backgroundOpacity = 0
        opacity           = 0
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        completion?()
      }
    }
  }
}

struct CustomAlertButton: View {
  
  let title: LocalizedStringResource
  var action: (() -> Void)?
  
  var body: some View {
    Button {
      action?()
    } label: {
      Text(title)
        .bold()
        .multilineTextAlignment(.center)
        .padding(.vertical)
        .frame(maxWidth: .infinity)
    }
  }
}

struct CustomAlertModifier {
  @ObservedObject var exportViewModel: ExportPlaylistViewModel
  @Binding private var isPresented: Bool
  private let dismissButton: CustomAlertButton
  private let primaryButton: CustomAlertButton?
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @State private var keyboardHeight: CGFloat = 0
}

extension CustomAlertModifier: ViewModifier {
  
  func body(content: Content) -> some View {
      ZStack(alignment: .top) {
      content
      if isPresented {
        // 얼럿이 띄워질 때 반투명한 뒷 배경을 추가
        Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
          .onTapGesture { // <-
            hideKeyboard()
          }
        CustomTitleAlert(
          setlist: setlist,
          artistInfo: artistInfo,
          dismissButton: dismissButton,
          primaryButton: primaryButton, exportViewModel: exportViewModel)
        .padding(.horizontal, 20)
        .padding(.top, UIScreen.main.bounds.height * 0.25)
        .zIndex(1) // 얼럿 창이 뒷 배경보다 위에 나타나도록 설정
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
        .offset(y: -keyboardHeight)
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                  withAnimation {
                    keyboardHeight = keyboardSize.height * 0.2
                  }
                }
            }

            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
              withAnimation {
                keyboardHeight = 0
              }
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
      }
    }
  }
  
    func hideKeyboard() {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension CustomAlertModifier {
  
  init(dismissButton: CustomAlertButton, primaryButton: CustomAlertButton?, isPresented: Binding<Bool>,
       artistInfo: ArtistInfo?,
       setlist: Setlist?,
       exportViewModel: ExportPlaylistViewModel
  )
  {
    self.dismissButton = dismissButton
    self.primaryButton   = primaryButton
    self._isPresented = isPresented
    self.artistInfo = artistInfo
    self.setlist = setlist
    self.exportViewModel = exportViewModel
  }
}
