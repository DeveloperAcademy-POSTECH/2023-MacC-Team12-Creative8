//
//  MainViewModel.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import Foundation

class MainViewModel: ObservableObject {
    @Published var selectedIndex: Int? 
    @Published var scrollToIndex: Int?
    @Published var isTapped: Bool = false
    
    let dateMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }()
    let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "YYYY"
        return formatter
    }()
    
    var sampleData: [MainArchiveData] = [
        MainArchiveData(image: "malone", artist: "Post\nMalone", concertInfo: [
            ConcertInfo(date: Date(), tourName: "Tour 1-1", venue: "Venue 1-1"),
            ConcertInfo(date: Date(), tourName: "Tour 1-2", venue: "Venue 1-2"),
            ConcertInfo(date: Date(), tourName: "Tour 1-3", venue: "Venue 1-3")
        ]),
        MainArchiveData(image: "youngk", artist: "영케이", concertInfo: [
            ConcertInfo(date: Date(), tourName: "Tour 2-1", venue: "Venue 2-1"),
            ConcertInfo(date: Date(), tourName: "Tour 2-2", venue: "Venue 2-2"),
            ConcertInfo(date: Date(), tourName: "Tour 2-3", venue: "Venue 2-3")
        ]),
        MainArchiveData(image: "koc", artist: "Kings of\nConvenience", concertInfo: [
            ConcertInfo(date: Calendar.current.date(from: DateComponents(year: 2022, month: 1, day: 1)) ?? Date(), tourName: "Tour 3-1", venue: "Venue 3-1"),
            ConcertInfo(date: Date(), tourName: "Tour 3-2", venue: "Venue 3-2"),
            ConcertInfo(date: Date(), tourName: "Tour 3-3", venue: "Venue 3-3")
        ]),
        MainArchiveData(image: "woodz", artist: "Woodz", concertInfo: [
            ConcertInfo(date: Date(), tourName: "Tour 4-1", venue: "Venue 4-1"),
            ConcertInfo(date: Date(), tourName: "Tour 4-2", venue: "Venue 4-2"),
            ConcertInfo(date: Date(), tourName: "Tour 4-3", venue: "Venue 4-3")
        ])
    ]
}

