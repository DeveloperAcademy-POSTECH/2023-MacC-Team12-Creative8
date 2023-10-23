//
//  ArtistInfoModel.swift
//  Core
//
//  Created by 고혜지 on 10/18/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

public struct ArtistInfo {
  public var name: String
  public var alias: String?
  public var mbid: String
  public var gid: Int?
  public var imageUrl: String?
  public var songList: [(String, String?)]?
}