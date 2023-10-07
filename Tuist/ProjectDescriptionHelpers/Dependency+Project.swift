//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 최효원 on 2023/10/06.
//

import ProjectDescription

extension TargetDependency {
    public enum Projcet {}
}

public extension TargetDependency.Projcet {
    static let Feature = TargetDependency.project(target: "Feature", path: .relativeToRoot("Projects/Feature"))
    static let Core = TargetDependency.project(target: "Core", path: .relativeToRoot("Projects/Core"))
    static let UI = TargetDependency.project(target: "UI", path: .relativeToRoot("Projects/UI"))
}
