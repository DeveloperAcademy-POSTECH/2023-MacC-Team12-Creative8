//
//  MainModel.swift
//  Feature
//
//  Created by 장수민 on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

struct MainBookmarkData: Identifiable {
    let id: Int
    let singer: String
    let concertName: String
    let dDay: String
    let month: String
    let day: String
    let image: String
    init(id: Int = 0, singer: String = "artist", concertName: String = "concertName", 
         dDay: String = "dDay", month: String = "month", day: String = "day", image: String = "") {
        self.id = id
        self.singer = singer
        self.concertName = concertName
        self.dDay = dDay
        self.month = month
        self.day = day
        self.image = image
    }
}

struct UpcomingEventData: Identifiable {
    let id = UUID()
    let singer: String
    let date: String
    let dDay: String
    let image: String
    init(singer: String = "artist", date: String = "date", dDay: String = "dDay", image: String = "image") {
        self.singer = singer
        self.date = date
        self.dDay = dDay
        self.image = image
    }
}

struct PopularArtistData {
    let singer: String
    let image: String
    let day1: String
    let month1: String
    let venue1: String
    let day2: String
    let month2: String
    let venue2: String
    let day3: String
    let month3: String
    let venue3: String
    init(singer: String = "artist", image: String = "", 
         day1: String = "day1", month1: String = "month1", venue1: String = "venue1",
         day2: String = "day2", month2: String = "month2", venue2: String = "venue2",
         day3: String = "day3", month3: String = "month3", venue3: String = "venue3") {
        self.singer = singer
        self.image = image
        self.day1 = day1
        self.month1 = month1
        self.venue1 = venue1
        self.day2 = day2
        self.month2 = month2
        self.venue2 = venue2
        self.day3 = day3
        self.month3 = month3
        self.venue3 = venue3
    }
}
