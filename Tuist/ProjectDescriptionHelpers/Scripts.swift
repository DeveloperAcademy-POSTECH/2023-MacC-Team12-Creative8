//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import ProjectDescription
import Foundation

public extension TargetScript {
  static let SwiftLintString = TargetScript.pre(
    script: """
    ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
            
    ${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
            
    """,
    name: "SwiftLint",
    basedOnDependencyAnalysis: false
  )
}
