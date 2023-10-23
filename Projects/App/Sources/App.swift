//
//  App.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import SwiftUI
import Feature
import SwiftData
import Core

@main
struct SetlistApp: App {
<<<<<<< HEAD
  var sharedModelContainer: ModelContainer = {
      let schema = Schema([
        SearchHistory.self
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
        MainView()
          .modelContainer(sharedModelContainer)
      }
=======
    var body: some Scene {
        WindowGroup {
          NavigationStack {
            SettingView()
          }
        }
>>>>>>> 5822be0fbd165b34e732c4d39c5f31d9ee3b71e4
    }
}
