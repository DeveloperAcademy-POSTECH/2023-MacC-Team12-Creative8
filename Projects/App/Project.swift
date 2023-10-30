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
    .CoreXLSX
  ],
  dependencies: [
    .Projcet.Feature,
    .SPM.CoreXLSX
  ],
  sources: ["Sources/**"],
  resources: ["Resources/**"],
  infoPlist: .file(path: "Support/Info.plist")
)
