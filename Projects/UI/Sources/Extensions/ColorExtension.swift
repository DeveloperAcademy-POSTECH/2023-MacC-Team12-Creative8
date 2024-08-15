//
//  Color+.swift
//  UI
//
//  Created by 고혜지 on 10/15/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import SwiftUI

public extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255
        let green = Double((hex >> 8) & 0xff) / 255
        let blue = Double((hex >> 0) & 0xff) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

public let setaBundle = Bundle(identifier: "com.creative8.seta.UI")
public extension Color {
  static var mainBlack: Color {
      Color("mainBlack", bundle: setaBundle)
  }
  
  static var mainOrange: Color {
      Color("mainOrange", bundle: setaBundle)
  }
  
  static var mainWhite: Color {
      Color("mainWhite", bundle: setaBundle)
  }
  
  static var gray6: Color {
    Color("gray6", bundle: setaBundle)
  }
  
  static var orange100: Color {
    Color("orange100", bundle: setaBundle)
  }
  
  static var toast1: Color {
    Color("toast1", bundle: setaBundle)
  }
  
  static var toast2: Color {
    Color("toast2", bundle: setaBundle)
  }

  static var ellipsis: Color {
    Color("ellipsis", bundle: setaBundle)
  }
  
  static var gray600: Color {
    Color("gray600", bundle: setaBundle)
  }
  
  static var toastBG: Color {
    Color("toastBG", bundle: setaBundle)
  }
  
  static var shareBG: Color {
    Color("shareBG", bundle: setaBundle)
  }
}
