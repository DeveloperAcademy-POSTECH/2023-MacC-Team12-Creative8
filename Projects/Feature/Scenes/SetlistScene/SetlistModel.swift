//
//  SetlistModel.swift
//  Feature
//
//  Created by 고혜지 on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

// MARK: Core에 있는 Model! 삭제 예정!

// MARK: - SetlistListModel
struct SetlistListModel: Codable {
    let type: String?
    let itemsPerPage: Int?
    let page: Int?
    let total: Int?
    let setlist: [Setlist]?
}

// MARK: - Setlist
struct Setlist: Codable {
    let id: String?
    let versionId: String?
    let eventDate: String?
    let lastUpdated: String?
    let artist: Artist?
    let venue: Venue?
    let sets: Sets?
    let url: String?
    let info: String?
    let tour: Tour?
}

// MARK: - Artist
struct Artist: Codable {
    let mbid: String?
    let name: String?
    let sortName: String?
    let disambiguation: String?
    let url: String?
}

// MARK: - Sets
struct Sets: Codable {
    let setsSet: [Session]?
    
    enum CodingKeys: String, CodingKey {
        case setsSet = "set"
    }
}

// MARK: - Session
struct Session: Codable {
    let song: [Song]?
    let encore: Int?
    let name: String?
}

// MARK: - Song
struct Song: Codable {
    let name: String?
    let info: String?
    let cover: Artist?
    let tape: Bool?
}

// MARK: - Tour
struct Tour: Codable {
    let name: String?
}

// MARK: - Venue
struct Venue: Codable {
    let id: String?
    let name: String?
    let city: City?
    let url: String?
}

// MARK: - City
struct City: Codable {
    let id: String?
    let name: String?
    let state: String?
    let stateCode: String?
    let coords: Coords?
    let country: Country?
}

// MARK: - Coords
struct Coords: Codable {
    let lat: Double?
    let long: Double?
}

// MARK: - Country
struct Country: Codable {
    let code: String?
    let name: String?
}



var dummySetlist: Setlist = Setlist(
    id: "7ba3ba94",
    versionId: "g6b8752a6",
    eventDate: "23-09-2023",
    lastUpdated: "2023-09-25T21:12:22.144+0000",
    
    artist: Artist(
        mbid: "b9545342-1e6d-4dae-84ac-013374ad8d7c",
        name: "IU",
        sortName: "IU",
        disambiguation: "",
        url: "https://www.setlist.fm/setlists/iu-23d56c2f.html"),
    
    venue: Venue(
        id: "73d3aad9",
        name: "Kspo Dome",
        city: City(
            id: "1835848",
            name: "Seoul",
            state: "Seoul",
            stateCode: "11",
            coords: Coords(
                lat: 37.5663889,
                long: 126.9997222),
            country: Country(
                code: "KR",
                name: "South Korea")),
        url: "https://www.setlist.fm/venue/kspo-dome-seoul-south-korea-73d3aad9.html"),
    
    sets: Sets(
        setsSet: [
            Session(
                song: [
                    Song(name: "Celebrity", info: nil, cover: nil, tape: nil),
                    Song(name: "Uaena Song", info: nil, cover: nil, tape: nil),
                    Song(name: "Give You My Heart", info: "Short version", cover: nil, tape: nil),
                    Song(name: "Secret Garden", info: nil, cover: nil, tape: nil),
                    Song(name: "Havana", info: nil, cover: nil, tape: nil)],
                encore: nil,
                name: "Part 1"),
            
            Session(
                song: [
                    Song(name: "Four Times Around the Sun", info: nil, cover: Artist(
                        mbid: "e156615d-3ddd-4491-9584-4b9d971472c4",
                        name: "NELL",
                        sortName: "NELL",
                        disambiguation: "Korean band",
                        url: "https://www.setlist.fm/setlists/nell-73d67a99.html"), tape: nil),
                    Song(name: "strawberry moon", info: "Acoustic version", cover: nil, tape: nil),
                    Song(name: "BBIBBI", info: nil, cover: nil, tape: nil),
                    Song(name: "Rover", info: "Dance Challenge", cover: Artist(
                        mbid: "6afff86d-fc4a-4446-a41e-f88e1322a5be",
                        name: "KAI",
                        sortName: "KAI",
                        disambiguation: "EXO",
                        url: "https://www.setlist.fm/setlists/kai-2bdd1476.html"), tape: true),
                    Song(name: "Coin", info: nil, cover: nil, tape: nil),
                    Song(name: "You Know", info: nil, cover: nil, tape: nil),
                    Song(name: "Blueming", info: nil, cover: nil, tape: nil),
                    Song(name: "Through the Night", info: "with Uaena", cover: nil, tape: nil),
                    Song(name: "Heart", info: "with Uaena", cover: nil, tape: nil)], 
                encore: nil,
                name: "Part 2"),
            
            Session(
                song: [
                    Song(name: "dlwlrma", info: "by Uaena in sing-along event during encore", cover: nil, tape: nil),
                    Song(name: "Empty Cup", info: nil, cover: nil, tape: nil),
                    Song(name: "Secret", info: "short version without accompaniment", cover: nil, tape: nil),
                    Song(name: "Windflower", info: nil, cover: nil, tape: nil),
                    Song(name: "Drama", info: nil, cover: nil, tape: nil)], 
                encore: nil,
                name: "Encore (done in en-encore style)")
        ]),
    
    url: "https://www.setlist.fm/setlist/iu/2023/kspo-dome-seoul-south-korea-7ba3ba94.html",
    info: nil,
    tour: Tour(name: "I+UN1VER5E 15th Debut Anniv Fan Concert")
)

let iuSongList = [("4AM", nil), ("입술 사이", Optional("50cm")), ("시간의 바깥", Optional("Above The Time")), ("A Dreamer", nil), ("우울시계", Optional("A Gloomy Clock")), ("어푸", Optional("Ah puh")), ("가을 아침", Optional("Autumn Morning")), ("싫은 날", Optional("Bad Day")), ("BBIBBI", Optional("삐삐")), ("Beautiful Dancer", nil), ("Black Out", nil), ("Blueming", nil), ("Blueming", Optional("English Translation")), ("", Optional("Bonus Track")), ("Boo", nil), ("꿍따리 샤바라", Optional("Boom Ladi Dadi")), ("개여울", Optional("By The Stream")), ("사랑이 잘", Optional("Can’t Love You Anymore")), ("고양이", Optional("Cat")), ("Celebrity", nil), ("Coin", nil), ("크레파스", Optional("Crayon")), ("한낮의 꿈", Optional("Daydream")), ("Dear Moon", nil), ("이름에게", Optional("Dear Name")), ("이 지금", Optional("dlwlrma")), ("그 애 참 싫다", Optional("Don’t Like Her")), ("드라마", Optional("Drama")), ("Dreamer", nil), ("여름밤의 꿈", Optional("Dreams in summer night")), ("에잇", Optional("eight")), ("에잇", Optional("eight")), ("빈 컵", Optional("Empty Cup")), ("이런 엔딩", Optional("Ending Scene")), ("이런 엔딩", Optional("Ending Scene")), ("에필로그", Optional("Epilogue")), ("누구나 비밀은 있다", Optional("Everybody Has Secrets")), ("누구나 아는 비밀", Optional("Everybody Knows the Secret")), ("매일 그대와", Optional("Everyday With You")), ("하루 끝", Optional("Every End of the Day")), ("Every Sweet Day", nil), ("Everything’s Alright", nil), ("? [EXTRAIT]", nil), ("Fairytale", nil), ("동화", Optional("Fairy Tale")), ("Feel So Good", nil), ("첫 겨울이니까", Optional("First Winter")), ("꽃", Optional("Flower")), ("Flu", nil), ("Follow the Moon", nil), ("금요일에 만나요", Optional("Friday")), ("마침표", Optional("Full Stop")), ("GANADARA", nil), ("마음을 드려요", Optional("Give You My Heart")), ("안경", Optional("Glasses")), ("좋은 날", Optional("Good Day")), ("좋은 날", Optional("Good Day")), ("Good Day - Japanese Version", nil), ("Greedyy", nil), ("Havana", nil), ("마음", Optional("Heart")), ("마음", Optional("heart")), ("그의 그대", Optional("Her")), ("있잖아", Optional("Hey")), ("봄 안녕 봄", Optional("Hi Spring Bye")), ("별을 찾는 아이", Optional("Holding a Star In My Heart")), ("내 손을 잡아", Optional("Hold my hand")), ("내 손을 잡아", Optional("Hold my hand")), ("최면", Optional("Hypnosis")), ("얼음꽃", Optional("Ice Flower")), ("I know", nil), ("Into the I-LAND", nil), ("IU", Optional("아이유")), ("잼잼", Optional("Jam Jam")), ("무릎", Optional("Knees")), ("무릎", Optional("Knees")), ("라망", Optional("L’amant")), ("Last Fantasy", nil), ("어젯밤 이야기", Optional("Last Night Story")), ("레옹", Optional("Leon")), ("라일락", Optional("LILAC")), ("혼자 있는 방", Optional("Lonely Room")), ("미아", Optional("Lost Child")), ("그렇게 사랑은", Optional("Love Alone")), ("Love Attack", nil), ("러브레터", Optional("Love Letter")), ("러브레터", Optional("Love Letter")), ("을의 연애", Optional("Love of B")), ("Love Poem", nil), ("Love Poem", nil), ("연애소설", Optional("Love Story")), ("자장가", Optional("Lullaby")), ("Marshmellow", Optional("마쉬멜로우")), ("너의 의미", Optional("Meaning of You")), ("바람의 멜로디", Optional("Melody of the Wind")), ("미리 메리 크리스마스", Optional("Merry Christmas Ahead")), ("Modern Times", nil), ("Monday Afternoon", nil), ("Mother Nature", Optional("H₂O")), ("Mother Nature", Optional("H₂O")), ("십이월 이십오일의 고백", Optional("My Christmas Wish")), ("친구야 친구", Optional("My Dear Friend")), ("My Dear Friend", Optional("Eun Birthday-Moonlovers")), ("My Dream Patissiere", nil), ("나의 옛날이야기", Optional("My Old Story")), ("My old story", Optional("English Translation")), ("아이와 나의 바다", Optional("My sea")), ("낙하", Optional("NAKKA")), ("New world", nil), ("정거장", Optional("Next Stop")), ("잔소리", Optional("Nitpicking")), ("이게 아닌데", Optional("Not Like This")), ("봄, 사랑, 벚꽃 말고", Optional("Not Spring, Love, Or Cherry Blossoms")), ("Obliviate", nil), ("비가 내리는 날", Optional("On a rainy day")), ("나만 몰랐던 이야기", Optional("Only I Didn’t Know")), ("나만 몰랐던 이야기", Optional("Only I Didn’t Know")), ("Ooh La La", nil), ("팔레트", Optional("Palette")), ("Palette", Optional("팔레트")), ("복숭아", Optional("Peach")), ("Peach romanized", nil), ("사람", Optional("People")), ("삐에로는 우릴 보고 웃지", Optional("Pierrot Laughs At Us")), ("Rain Drop", nil), ("Rain Drop - Japanese Version", nil), ("Real Love", nil), ("Red Queen", nil), ("Reload", nil), ("기차를 타고", Optional("Riding On a Train")), ("길", Optional("Road")), ("잔혹동화", Optional("Scary Fairy Tale")), ("달빛바다", Optional("Sea of Moonlight")), ("비밀", Optional("Secret")), ("비밀의 화원", Optional("Secret Garden")), ("새 신발", Optional("Shoes")), ("잠자는 숲 속의 왕자", Optional("Sleeping Prince")), ("잠 못 드는 밤 비는 내리고", Optional("Sleepless Rainy Night")), ("작은 방", Optional("Small Room")), ("소격동", Optional("Sogyeokdong")), ("Someday", nil), ("노래 불러줘요", Optional("Song for You")), ("SoulMate", nil), ("​strawberry moon", nil), ("Teacher", nil), ("That Day", nil), ("길 잃은 강아지", Optional("The Abandoned")), ("The Age of the Cathedrals", nil), ("첫 이별 그날 밤", Optional("The Night of the First Breakup")), ("분홍신", Optional("The Red Shoes")), ("푸르던", Optional("The Shower")), ("눈사람", Optional("The Snowman")), ("미운오리", Optional("The Ugly Duckling")), ("그 사람", Optional("The Visitor")), ("그 사람", Optional("The Visitor")), ("밤편지", Optional("Through the Night")), ("돌림노래", Optional("Troll")), ("Truth", nil), ("스물셋", Optional("Twenty-Three")), ("어허야 둥기둥기", Optional("Uhuya Doongi Doongi")), ("삼촌", Optional("Uncle")), ("Unlucky", nil), ("Unlucky", Optional("English Translation")), ("Unreleased Song", nil), ("기다려", Optional("Wait")), ("아이야 나랑 걷자", Optional("Walk With Me, Girl")), ("벽지무늬", Optional("Wallpaper Pattern")), ("느리게 하는 일", Optional("What I’m Doing Slow")), ("사랑이 지나가면", Optional("When Love Passes By")), ("When You Fall", nil), ("When You Fall", Optional("Translation")), ("겨울잠", Optional("Winter Sleep")), ("사랑니", Optional("Wisdom Tooth")), ("희망사항", Optional("Wish List")), ("너", Optional("You")), ("You Are A Miracle", nil), ("너랑 나", Optional("You & I")), ("You & I - Japanese Version", nil), ("제제", Optional("Zezé")), ("少年時代", Optional("Boyhood"))]
