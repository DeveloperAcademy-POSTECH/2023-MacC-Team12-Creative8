//
//  TabBarView.swift
//  Feature
//
//  Created by 최효원 on 10/23/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import UI
import Combine
import Core

struct NavigationDelivery: Hashable {
  var setlistId: String?
  var artistInfo: SaveArtistInfo
}

class TabViewManager: ObservableObject {
  @Published var pageStack: [NavigationDelivery] = []
  @Published var scrollToTop: Bool = false
  
  private var subscription: AnyCancellable?
  
  init(consecutiveTaps: AnyPublisher<Void, Never>) {
    subscription = consecutiveTaps
      .sink { [weak self] in
        guard let self else { return }
        
        if pageStack.isEmpty {
          scrollToTop = true
        } else {
          pageStack.removeLast()
        }
        
      }
  }
}

final class TabViewModel: ObservableObject {
  @Published var selectedTab: Tab = .home
  
  typealias PairwiseTabs = (previous: Tab?, current: Tab)
  
  func consecutiveTaps(on tab: Tab) -> AnyPublisher<Void, Never> {
    $selectedTab
      .scan(PairwiseTabs(previous: nil, current: selectedTab)) { previousPair, current in
        PairwiseTabs(previous: previousPair.current, current: current)
      }
      .filter { $0.previous == $0.current}
      .compactMap { $0.current == tab ? Void() : nil}
      .eraseToAnyPublisher()
  }
}

public struct TabBarView: View {
  @StateObject var viewModel = TabViewModel()
  @Environment(NetworkMonitor.self) private var networkMonitor
  
  public init() {
    let appearance = UITabBarAppearance()
    let tabBar = UITabBar.appearance()
    
    appearance.shadowColor = UIColor.clear
    appearance.backgroundColor = UIColor(named: "mainWhite", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)
    tabBar.backgroundColor = UIColor(named: "mainWhite", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)
    
    appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "mainBlack", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)
    appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "mainBlack", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)]
    
    appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray
    appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray]

    tabBar.standardAppearance = appearance
  }
  
  public var body: some View {
    TabView(selection: $viewModel.selectedTab) {
      Group {
        MainView(selectedTab: $viewModel.selectedTab, tabViewManager: TabViewManager(consecutiveTaps: viewModel.consecutiveTaps(on: .home)))
          .navigationBarTitleDisplayMode(.inline)
          .tabItem {
            Image("setlistIcon", bundle: Bundle(identifier: "com.creative8.seta.UI"))
              .renderingMode(.template)
            Text("세트리스트")
          }
          .tag(Tab.home)
        
        SearchView(selectedTab: $viewModel.selectedTab, tabViewManager: TabViewManager(consecutiveTaps: viewModel.consecutiveTaps(on: .search)))
          .navigationBarTitleDisplayMode(.inline)
          .tabItem {
            Image("searchIcon", bundle: Bundle(identifier: "com.creative8.seta.UI"))
              .renderingMode(.template)
            Text("검색")
          }
          .tag(Tab.search)
        
        ArchivingView(selectedTab: $viewModel.selectedTab, tabViewManager: TabViewManager(consecutiveTaps: viewModel.consecutiveTaps(on: .archiving)))
          .navigationBarTitleDisplayMode(.large)
          .tabItem {
            Image("archiveIcon", bundle: Bundle(identifier: "com.creative8.seta.UI"))
              .renderingMode(.template)
            Text("보관함")
          }
          .tag(Tab.archiving)
        
        NavigationStack {
          SettingView()
            .navigationBarTitleDisplayMode(.large)
        }
        .tabItem { Label("더보기", systemImage: "ellipsis") }
        .tag(Tab.setting)
      }
      .overlay {
        if !networkMonitor.isConnected {
          NetworkUnavailableView()
        }
      }
    }
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
