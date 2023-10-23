//
//  ArchiveDataModel.swift
//  Feature
//
//  Created by 장수민 on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import SwiftData

@Model
class ArchivedConcertInfo {
    var id: String
    var versionId: String
    var eventDate: Date
    var lastUpdated: String
    var artist: String
    var venue: String
    var sets: [String]
    var url: String
    var info: String?
    var tour: String
// 데이터를 저장할 때는 artist, venue, sets 같은거 굳이 이렇게 안하고 그냥 String으로 받으면 안되는걸까?...
    init(id: String, versionId: String, eventDate: Date, lastUpdated: String, artist: String, venue: String, sets: [String], url: String, info: String?, tour: String) {
        self.id = id
        self.versionId = versionId
        self.eventDate = eventDate
        self.lastUpdated = lastUpdated
        self.artist = artist
        self.venue = venue
        self.sets = sets
        self.url = url
        self.info = info ?? ""
        self.tour = tour
    }
}
//@Model
//class ArchivedConcertInfo {
//    var id: String
//    var versionId: String
//    var eventDate: Date
//    var lastUpdated: String
//    var artist: Artist
//    var venue: Venue
//    var sets: Sets
//    var url: String
//    var info: String?
//    var tour: Tour
//// 데이터를 저장할 때는 artist, venue, sets 같은거 굳이 이렇게 안하고 그냥 String으로 받으면 안되는걸까?...
//    init(id: String, versionId: String, eventDate: Date, lastUpdated: String, artist: Artist, venue: Venue, sets: Sets, url: String, info: String?, tour: Tour) {
//        self.id = id
//        self.versionId = versionId
//        self.eventDate = eventDate
//        self.lastUpdated = lastUpdated
//        self.artist = artist
//        self.venue = venue
//        self.sets = sets
//        self.url = url
//        self.info = info ?? ""
//        self.tour = tour
//    }
//}
//
//class Artist {
//    var mbid: String
//    var name: String
//    var sortName: String
//    var disambiguation: String
//    var url: String
//
//    init(mbid: String, name: String, sortName: String, disambiguation: String, url: String) {
//        self.mbid = mbid
//        self.name = name
//        self.sortName = sortName
//        self.disambiguation = disambiguation
//        self.url = url
//    }
//}
//
//class Venue {
//    var id: String
//    var name: String
//    var city: City
//    var url: String
//
//    init(id: String, name: String, city: City, url: String) {
//        self.id = id
//        self.name = name
//        self.city = city
//        self.url = url
//    }
//}
//
//class City {
//    var id: String
//    var name: String
//    var state: String
//    var stateCode: String
//    var coords: Coords
//    var country: Country
//
//    init(id: String, name: String, state: String, stateCode: String, coords: Coords, country: Country) {
//        self.id = id
//        self.name = name
//        self.state = state
//        self.stateCode = stateCode
//        self.coords = coords
//        self.country = country
//    }
//}
//
//class Coords {
//    var lat: Double
//    var long: Double
//
//    init(lat: Double, long: Double) {
//        self.lat = lat
//        self.long = long
//    }
//}
//
//class Country {
//    var code: String
//    var name: String
//
//    init(code: String, name: String) {
//        self.code = code
//        self.name = name
//    }
//}
//
class Sets {
    var setsSet: [Session]

    init(setsSet: [Session]) {
        self.setsSet = setsSet
    }
}

class Session {
    var song: [Song]
    var encore: String?
    var name: String

    init(song: [Song], encore: String?, name: String) {
        self.song = song
        self.encore = encore
        self.name = name
    }
}

class Song {
    var name: String
    var info: String?
    var cover: String?
    var tape: Bool?

    init(name: String, info: String?, cover: String?, tape: Bool?) {
        self.name = name
        self.info = info
        self.cover = cover
        self.tape = tape
    }
}
//
//class Tour {
//    var name: String
//
//    init(name: String) {
//        self.name = name
//    }
//}
