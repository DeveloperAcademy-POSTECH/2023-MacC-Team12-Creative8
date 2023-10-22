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
