//
//  ConcertListViewModel.swift
//  Feature
//
//  Created by 장수민 on 10/17/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation
import SwiftData

@Observable
class DataManager: ObservableObject {
    var context: ModelContext? = nil
    var concerts: [ArchivedConcertInfo] = []
    // 아카이빙 한 콘서트의 년도를 배열로 만듦
    var concertYears: [String] = []
    // 사용자가 선택한 년도
    var selectedYear: Int = 0
    
    func fetchConcerts() {
        let fetchDescriptor = FetchDescriptor<ArchivedConcertInfo>(
            sortBy: [SortDescriptor(\.eventDate)]
        )
        concerts = (try? (context?.fetch(fetchDescriptor) ?? [])) ?? []
    }
    func addItem(id: String, versionId: String, dateString: String, lastUpdated: String, artist: String, venue: String, sets: [String], url: String, info: String?, tour: String) {
        if let eventDate = convertStringToDate(dateString, format: "dd-MM-yyyy") {
            let item = ArchivedConcertInfo(id: id, versionId: versionId, eventDate: eventDate, lastUpdated: lastUpdated, artist: artist, venue: venue, sets: sets, url: url, info: info, tour: tour)
            context?.insert(item)
            fetchConcerts()
            self.save()
            print("저장됨")
        } else {
            print("유효하지 않은 날짜 형식입니다.")
        }
    }
    func deleteItem(item: ArchivedConcertInfo) {
        context?.delete(item)
        fetchConcerts()
        self.save()
        print("삭제됨")
    }
    func save() {
            do {
                try context?.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    func isConcertsEmpty() -> Bool {
        return concerts.isEmpty
    }
    // 아카이빙 한 콘서트들의 년도를 배열로 만드는 함수
    func separateConcertsByYear() {
        fetchConcerts()
        let calendar = Calendar.current
            let years = Set(concerts.map { calendar.component(.year, from: $0.eventDate) })
        concertYears = years.sorted().map { String($0) }.reversed() // 최근부터 보여주기 위해
        }
    // 년도 배열을 토대로 콘서트를 필터링해주는 함수
    func filterConcerts(byYear year: Int) -> [ArchivedConcertInfo] {
        fetchConcerts()
        let calendar = Calendar.current
        return concerts.filter { calendar.component(.year, from: $0.eventDate) == year }
    }
    func convertStringToDate(_ dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
}

