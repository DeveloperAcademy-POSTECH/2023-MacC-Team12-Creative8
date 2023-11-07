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

  public init() {
    UITabBar.appearance().backgroundColor = UIColor(named: "backgroundWhite", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)
  }

  public var body: some View {
    TabView(selection: $selectedTab) {
      NavigationStack {
        MainView(selectedTab: $selectedTab)
      }
      .tabItem {
        Label("세트리스트", systemImage: "music.note.house.fill")
      }
      .tag(Tab.home)
      NavigationStack {
        SearchView(selectedTab: $selectedTab)
      }
      .tabItem {
        Label("검색", systemImage: "magnifyingglass")
      }
      .tag(Tab.search)
      NavigationStack {
        ArchivingView(selectedTab: $selectedTab)
          .background(Color.backgroundWhite)
      }
      .tabItem {
        Label("보관함", systemImage: "heart.fill")
      }
      .tag(Tab.archiving)

      NavigationStack {
        SettingView()
          .background(Color.backgroundWhite)
      }
      .tabItem {
        Label("더보기", systemImage: "ellipsis")
      }
      .tag(Tab.setting)
    }
  }
}

enum Tab {
  case home
  case search
  case archiving
  case setting
}
