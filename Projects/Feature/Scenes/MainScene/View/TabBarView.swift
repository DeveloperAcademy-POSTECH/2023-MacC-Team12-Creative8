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
  
  enum Tab {
    case home
    case search
    case archiving
    case setting
  }
  
  public init() {
  }
  
  public var body: some View {
    TabView(selection: $selectedTab) {
      NavigationStack {
        MainView()
      }
      .tabItem {
        Label("세트리스트", systemImage: "music.note.house.fill")
      }
      .tag(Tab.home)
      NavigationStack {
        SearchView()
      }
      .tabItem {
        Label("검색", systemImage: "magnifyingglass")
      }
      .tag(Tab.search)

      NavigationStack {
        ArchivingView()
      }
      .tabItem {
        Label("아카이빙", systemImage: "heart.fill")
      }
      .tag(Tab.archiving)

      NavigationStack {
        SettingView()
      }
      .tabItem {
        Label("더보기", systemImage: "ellipsis")
      }
      .tag(Tab.setting)
    }
    .navigationTitle(selectedTab == .archiving ? "보관함" : selectedTab == .setting ? "더보기" : "")
    .onAppear {
      UITabBar.appearance().backgroundColor = UIColor(named: "backgroundWhite")
    }
  }
}
