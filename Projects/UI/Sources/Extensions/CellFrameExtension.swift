//
//  CellFrameExtension.swift
//  UI
//
//  Created by A_Mcflurry on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI

public extension View {
  func frameForCell() -> some View {
    self.frame(width: getCellFrame(), height: getCellFrame())
  }
  private func getCellFrame() -> CGFloat {
    return 56
  }
}
