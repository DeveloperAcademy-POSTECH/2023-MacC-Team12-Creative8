//
//  DateFormaterExtension.swift
//  UI
//
//  Created by A_Mcflurry on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

public extension DateFormatter {
    static func monthDayFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }
}
