//
//  SetlistModel.swift
//  Feature
//
//  Created by 고혜지 on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

struct Song {
    let title: String
    let info: [String]?
}

struct Session {
    let sessionName: String?
    let isTape: Bool
    let songs: [Song]
}

var dummySetlist: [Session] = [
    Session(sessionName: "Song played from the tape", isTape: true, songs: [
        Song(title: "긴 곡 제목이면 여기까지 포함됩니다...", info: nil),
        Song(title: "곡 제목이 들어갑니다", info: nil),
    ]),
    Session(sessionName: nil, isTape: false, songs: [
        Song(title: "곡 제목", info: nil),
        Song(title: "곡 제목", info: nil),
        Song(title: "곡 제목", info: nil),
        Song(title: "곡 제목이 들어갑니다", info: ["(주석이 들어갑니다)"]),
        Song(title: "곡 제목", info: nil),
        Song(title: "곡 제목", info: nil),
        Song(title: "곡 제목이 들어갑니다", info: ["(한 줄 이상의 주석이 들어갈때)", "(이런식으로 배치됩니다)"]),
    ]),
    Session(sessionName: "Encore", isTape: false, songs: [
        Song(title: "곡 제목", info: nil),
        Song(title: "곡 제목", info: nil),
    ]),
]
