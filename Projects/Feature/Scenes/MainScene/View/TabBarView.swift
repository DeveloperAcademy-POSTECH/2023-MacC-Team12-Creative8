//
//  TabBarView.swift
//  Feature
//
//  Created by 최효원 on 10/23/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI

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
      MainView()
        .tabItem {
          Label("세트리스트", systemImage: "music.note.house.fill")
        }
        .tag(Tab.home)
      
      SearchView()
        .tabItem {
          Label("검색", systemImage: "magnifyingglass")
        }
        .tag(Tab.search)
      
      ArchivingView()
        .tabItem {
          Label("아카이빙", systemImage: "heart.fill")
        }
        .tag(Tab.archiving)
      
      SettingView()
        .tabItem {
          Label("더보기", systemImage: "ellipsis")
        }
        .tag(Tab.setting)
    }
    .accentColor(.blue)
    .navigationBarBackButtonHidden(true)
  }
}
