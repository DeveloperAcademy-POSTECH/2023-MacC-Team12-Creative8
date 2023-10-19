//
//  AskView.swift
//  Feature
//
//  Created by 예슬 on 2023/10/15.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import MessageUI

struct AskView: View {
  
  @ObservedObject var coordinator = Coordinator()
  
  var body: some View {
    Button(action: {
      commentsButtonTapped()
    }, label: {
      HStack {
        Text("문의하기")
          .font(.system(.footnote, weight: .semibold))
          .padding(EdgeInsets(top: 24, leading: 26, bottom: 24, trailing: 0))
        Spacer(minLength: 231)
        Image(systemName: "chevron.right")
          .resizable()
          .frame(width: 6, height: 12)
          .padding(EdgeInsets(top: 22, leading: 0, bottom: 22, trailing: 36))
      }
      .frame(width: 350, height: 66)
      .background(.white)
      .foregroundStyle(.black)
      .cornerRadius(12)
      .padding(.bottom, 91)
    })
  }
  
  func commentsButtonTapped() {
    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootViewController = windowScene.windows.first?.rootViewController else {
        return
    }
//    guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
//      return
//    }
    
    if MFMailComposeViewController.canSendMail() {
      let composeViewController = MFMailComposeViewController()
      composeViewController.mailComposeDelegate = coordinator
      
      let bodyString = """
                             // 이메일 내용
                             """
      
      composeViewController.setToRecipients(["thecreative8team@gmail.com"])
      composeViewController.setSubject("<SETA> 문의 및 의견")
      composeViewController.setMessageBody(bodyString, isHTML: false)
      
      if let presented = rootViewController.presentedViewController {
        presented.dismiss(animated: false) {
          rootViewController.present(composeViewController, animated: true, completion: nil)
        }
      } else {
        rootViewController.present(composeViewController, animated: true, completion: nil)
      }
    } else {
      print("메일 보내기 실패")
      let sendMailErrorAlert = UIAlertController(
        title: "메일 전송 실패",
        message: "메일을 보내려면 'Mail' 앱이 필요합니다. App Store에서 해당 앱을 복원하거나 이메일 설정을 확인하고 다시 시도해주세요.",
        preferredStyle: .alert)
      let goAppStoreAction = UIAlertAction(title: "App Store로 이동하기", style: .default) { _ in
        if let url = URL(
          string: "https://apps.apple.com/kr/app/mail/id1108187098"), UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
      }
      let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
      
      sendMailErrorAlert.addAction(goAppStoreAction)
      sendMailErrorAlert.addAction(cancelAction)
      rootViewController.present(sendMailErrorAlert, animated: true, completion: nil)
    }
  }
  
  class Coordinator: NSObject, MFMailComposeViewControllerDelegate, ObservableObject {
    func mailComposeController(
      _ controller: MFMailComposeViewController, didFinishWith
      result: MFMailComposeResult,
      error: Error?) {
        controller.dismiss(animated: true, completion: nil)
      }
  }
}

#Preview {
  AskView()
}
