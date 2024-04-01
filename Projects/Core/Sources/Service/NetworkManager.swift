//
//  NetworkManager.swift
//  Core
//
//  Created by 장수민 on 2/26/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import Foundation
import Network

@Observable
public final class NetworkMonitor: ObservableObject {
  public let networkMonitor = NWPathMonitor()
  public let queue = DispatchQueue(label: "Monitor")
  public var isConnected = false

  public init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: queue)
    }
  
  public func startMonitoring() {
    networkMonitor.start(queue: queue)
    networkMonitor.pathUpdateHandler = { path in
          self.isConnected = path.status == .satisfied
          
          if path.usesInterfaceType(.wifi) {
              print("Using wifi")
          } else if path.usesInterfaceType(.cellular) {
              print("Using cellular")
          }
      }
  }
}
