//
//  TabBarView.swift
//  Feature
//
//  Created by 최효원 on 10/23/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI

public struct TabBarView: View {
  @State private var selectedTab: Tab = .home
  @Environment(\.dismiss) var dismiss
  public init() {
    UITabBar.appearance().backgroundColor = UIColor(named: "backgroundWhite", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)
  }
  
  public var body: some View {
    TabView(selection: $selectedTab.onUpdate{ myFunction(item: selectedTab) }) {
      NavigationStack {
        MainView(selectedTab: $selectedTab)
          .navigationBarTitleDisplayMode(.inline)
      }
      .tabItem {
        Label("세트리스트", systemImage: "music.note.house.fill")
      }
      .tag(Tab.home)
      NavigationStack {
        SearchView(selectedTab: $selectedTab)
          .navigationBarTitleDisplayMode(.inline)
      }
      .tabItem {
        Label("검색", systemImage: "magnifyingglass")
      }
      .tag(Tab.search)
      NavigationStack {
        ArchivingView(selectedTab: $selectedTab)
          .navigationBarTitleDisplayMode(.large)
          .background(Color.backgroundWhite)
      }
      .tabItem {
        Label("보관함", systemImage: "heart.fill")
      }
      .tag(Tab.archiving)
      
      NavigationStack {
        SettingView()
          .navigationBarTitleDisplayMode(.large)
          .background(Color.backgroundWhite)
      }
      .tabItem {
        Label("더보기", systemImage: "ellipsis")
      }
      .tag(Tab.setting)
    }
  }
  func myFunction(item: Tab) {

  }
}

extension Binding {
  func onUpdate(_ closure: @escaping () -> Void) -> Binding<Value> {
    Binding(get: {
      wrappedValue
    }, set: { newValue in
      wrappedValue = newValue
      closure()
    })
  }
}

enum Tab {
  case home
  case search
  case archiving
  case setting
}
