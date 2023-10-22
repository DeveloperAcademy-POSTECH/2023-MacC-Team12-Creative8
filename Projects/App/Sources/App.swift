//
//  App.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import SwiftUI
import SwiftData
import Feature
import Core

@main
struct SetlistApp: App {

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        MainView()
      }
    }
    .modelContainer(for: [ArchivedConcertInfo.self, LikeArtist.self, SearchHistory.self])
  }
}
