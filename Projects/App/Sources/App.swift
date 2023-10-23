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
    @AppStorage("appearance")
    var appearnace: ButtonType = .automatic
    
  var sharedModelContainer: ModelContainer = {
      let schema = Schema([
        LikeArtist.self, ArchivedConcertInfo.self, SearchHistory.self, Titles.self
      ])
      let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

      do {
          return try ModelContainer(for: schema, configurations: [modelConfiguration])
      } catch {
          fatalError("Could not create ModelContainer: \(error)")
      }
  }()

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        TabBarView()
              .preferredColorScheme(appearnace.getColorScheme())
      }
    }
    .modelContainer(sharedModelContainer)
  }
}
