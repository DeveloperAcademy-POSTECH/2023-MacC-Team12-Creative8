//
//  ToastMessageView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

struct ToastMessageView: View {
  let message: LocalizedStringResource
  let subMessage: LocalizedStringResource?
  let icon: String
  let color: Color
  
  var body: some View {
     HStack {
       VStack(alignment: .leading) {
         Text(message)
          .foregroundStyle(Color.mainWhite)
          .font(.subheadline)
         if let subMessage = subMessage {
           Text(subMessage)
            .foregroundStyle(Color.toast1)
            .font(.subheadline)
         }
       }
       Spacer()
       Image(systemName: icon)
         .renderingMode(.template)
         .foregroundStyle(color)
     }
     .padding(15)
     .frame(maxWidth: .infinity)
     .background(Blur().cornerRadius(6.0))
     .background(Color.toastBG.cornerRadius(6.0))
  }
}

open class UIBackdropView: UIView {

  open override class var layerClass: AnyClass {
    NSClassFromString("CABackdropLayer") ?? CALayer.self
  }
}

public struct Backdrop: UIViewRepresentable {

  public init() {}

  public func makeUIView(context: Context) -> UIBackdropView {
    UIBackdropView()
  }

  public func updateUIView(_ uiView: UIBackdropView, context: Context) {}
}

public struct Blur: View {

  public var radius: CGFloat
  public var opaque: Bool

  public init(radius: CGFloat = 3.0, opaque: Bool = false) {
    self.radius = radius
    self.opaque = opaque
  }

  public var body: some View {
    Backdrop()
      .blur(radius: radius, opaque: opaque)
  }
}
