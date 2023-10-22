//
//  UIScreenExtension.swift
//  UI
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

public extension View {
  var UIWidth: CGFloat {
      return UIScreen.main.bounds.width
  }

  var UIHeight: CGFloat {
      return UIScreen.main.bounds.height
  }
}
