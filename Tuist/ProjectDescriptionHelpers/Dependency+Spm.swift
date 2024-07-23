//
//  Dependency+Spm.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import ProjectDescription

public extension TargetDependency {
  enum SPM {}
}

public extension Package {
  static let Firebase = Package.remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "10.17.0"))
  static let Marquee = Package.remote(url: "https://github.com/SwiftUIKit/Marquee.git", requirement: .upToNextMajor(from: "0.3.0"))
  static let Facebook = Package.remote(url: "https://github.com/facebook/facebook-ios-sdk.git", requirement: .upToNextMajor(from: "14.1.0"))
}

public extension TargetDependency.SPM {
  static let Firebase = TargetDependency.package(product: "FirebaseAnalytics")
  static let Marquee = TargetDependency.package(product: "Marquee")
  static let Facebook = TargetDependency.package(product: "FacebookShare") 
}
