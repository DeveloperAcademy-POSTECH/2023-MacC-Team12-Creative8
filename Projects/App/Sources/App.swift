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
import Firebase

@main
struct SetlistApp: App {
  @AppStorage("appearance")
  var appearnace: ButtonType = .automatic
  @AppStorage("isOnboarding")
  var isOnboarding: Bool = true
  
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      ArchivedConcertInfo.self, LikeArtist.self, SearchHistory.self
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  init() {
    FirebaseApp.configure()
  }
  
  var body: some Scene {
    WindowGroup {
      if isOnboarding {
        OnboardingView()
      } else {
        
        TabBarView()
          .preferredColorScheme(appearnace.getColorScheme())
      }
    }
    .modelContainer(sharedModelContainer)
    
  }
}

extension UINavigationController {
  open override func viewWillLayoutSubviews() {
    navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
}
