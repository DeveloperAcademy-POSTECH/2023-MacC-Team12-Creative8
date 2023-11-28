//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Core",
  product: .framework,
  packages: [
    .GoogleSignIn
  ],
  dependencies: [
    .SPM.GoogleSignIn
  ],
  sources: ["Sources/**"]
)
