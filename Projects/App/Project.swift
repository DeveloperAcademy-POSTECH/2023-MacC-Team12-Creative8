//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Seta",
  platform: .iOS,
  product: .app,
  packages: [
    .remote(
      url: "https://github.com/firebase/firebase-ios-sdk.git",
      requirement: .upToNextMajor(from: "10.17.0")
    )
  ],
  dependencies: [
    .Projcet.Feature,
    .package(product: "FirebaseAnalytics")
  ],
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  infoPlist: .file(path: "Support/Info.plist")
)
