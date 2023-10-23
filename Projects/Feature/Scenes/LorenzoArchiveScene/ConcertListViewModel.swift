//
//  ConcertListViewModel.swift
//  Feature
//
//  Created by 장수민 on 10/22/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import SwiftUI

class ConcertListViewModel: ObservableObject {
    @Published var userSelection = "music.note.list"
    let options = ["music.note.list", "batteryblock"]
    @Published var concertYears: [String] = []
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
    func getAllConcertYears(concerts: [BookmarkedConcert]) -> [String] {
        var years: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        for concert in concerts {
            let year = dateFormatter.string(from: concert.date)
            if !years.contains(year) {
                years.append(year)
            }
        }
        return years
    }
    // MARK: 임시로 만든 데이터입니다. 나중에 스위프트데이터로 바꾸고 지우겠습나더
    let sampleBookmarkedConcerts: [BookmarkedConcert] = [
        // Artist 1
        BookmarkedConcert(artist: "Artist1", date: Date(), tourName: "TourName1", venue: "Venue1"),
        BookmarkedConcert(artist: "Artist1", date: Date(), tourName: "TourName2", venue: "Venue2"),
        BookmarkedConcert(artist: "Artist1", date: Calendar.current.date(from: DateComponents(year: 2022, month: 2, day: 1))!,
                          tourName: "TourName3", venue: "Venue3"),
        BookmarkedConcert(artist: "Artist1", date: Calendar.current.date(from: DateComponents(year: 2022, month: 4, day: 6))!, tourName: "TourName4", venue: "Venue4"),
        // Artist 2
        BookmarkedConcert(artist: "Artist2", date: Date(), tourName: "TourName1", venue: "Venue1"),
        BookmarkedConcert(artist: "Artist2", date: Date(), tourName: "TourName2", venue: "Venue2"),
        BookmarkedConcert(artist: "Artist2", date: Calendar.current.date(from: DateComponents(year: 2022, month: 8, day: 1))!, tourName: "TourName3", venue: "Venue3"),
        BookmarkedConcert(artist: "Artist2", date: Date(), tourName: "TourName4", venue: "Venue4"),
        // Artist 3
        BookmarkedConcert(artist: "Artist3", date: Calendar.current.date(from: DateComponents(year: 2022, month: 9, day: 1))!,
                          tourName: "TourName1", venue: "Venue1"),
        BookmarkedConcert(artist: "Artist3", date: Calendar.current.date(from: DateComponents(year: 2022, month: 7, day: 1))!, tourName: "TourName2", venue: "Venue2"),
        BookmarkedConcert(artist: "Artist3", date: Date(), tourName: "TourName3", venue: "Venue3"),
        BookmarkedConcert(artist: "Artist3", date: Date(), tourName: "TourName4", venue: "Venue4")
    ]
}
