//
//  MainModel.swift
//  Feature
//
//  Created by 장수민 on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

struct MainBookMarkData: Identifiable {
    let id: Int
    let singer: String
    let concertName: String
    let dDay: String
    let month: String
    let day: String
    let image: String
}

struct UpcomingEventData: Identifiable {
    let id = UUID()
    let singer: String
    let date: String
    let dDay: String
    let image: String
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
}
