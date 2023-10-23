//
//  ConcertListViewModel.swift
//  Feature
//
//  Created by 장수민 on 10/22/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import SwiftUI

final class ConcertListViewModel: ObservableObject {
    @Published var userSelection = "music.note.list"
    let options = ["music.note.list", "batteryblock"]
    @Published var concertYears: [(Int, Int)] = []
    // 월.일 형태
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }()
    // 요일 형태
    let dayOfWeekFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E"
        return formatter
    }()
}
