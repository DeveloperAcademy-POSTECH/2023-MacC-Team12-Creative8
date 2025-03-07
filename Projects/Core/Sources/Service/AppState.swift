//
//  AppState.swift
//  Core
//
//  Created by 예슬 on 3/7/25.
//  Copyright © 2025 com.creative8.seta. All rights reserved.
//

import Foundation

public class AppState: ObservableObject {
    @Published public var isOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(isOnboarding, forKey: "isOnboarding")
        }
    }
    
    public init() {
      if UserDefaults.standard.object(forKey: "isOnboarding") == nil {
             self.isOnboarding = true
             UserDefaults.standard.set(true, forKey: "isOnboarding")
         } else {
             self.isOnboarding = UserDefaults.standard.bool(forKey: "isOnboarding")
         }
    }
}
