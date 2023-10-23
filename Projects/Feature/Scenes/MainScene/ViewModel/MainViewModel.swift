//
//  MainViewModel.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import Foundation
import SwiftUI

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
        MainArchiveData(image: "malone", artist: "Post Malone", concertInfo: [
            ConcertInfo(date: Date(), tourName: "Tour 1-1", venue: "Venue 1-1"),
            ConcertInfo(date: Date(), tourName: "Tour 1-2", venue: "Venue 1-2"),
            ConcertInfo(date: Date(), tourName: "Tour 1-3", venue: "Venue 1-3")
        ]),
        MainArchiveData(image: "youngk", artist: "영케112313123이000", concertInfo: [
            ConcertInfo(date: Date(), tourName: "Tour 2-1", venue: "Venue 2-1"),
            ConcertInfo(date: Date(), tourName: "Tour 2-2", venue: "Venue 2-2"),
            ConcertInfo(date: Date(), tourName: "Tour 2-3", venue: "Venue 2-3")
        ]),
        MainArchiveData(image: "koc", artist: "Kings of Convenience", concertInfo: [
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
    
    func replaceFirstSpaceWithNewline(_ input: String) -> String {
        guard let range = input.rangeOfCharacter(from: .whitespaces) else {
            return input
        }
        return input.replacingCharacters(in: range, with: "\n")
    }
}

public enum ButtonType: Int, CaseIterable, Identifiable {
    public var id: Int { self.rawValue }
    case dark, light, automatic
    
   public var icon: String {
        switch self {
        case .automatic:
            return "circle.lefthalf.filled"
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        }
    }
    
    public var name: String {
        switch self {
        case .light: return "라이트"
        case .dark: return "다크"
        case .automatic: return "자동"
        }
    }
    
    public func getColorScheme() -> ColorScheme? {
        switch self {
        case .automatic: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}
