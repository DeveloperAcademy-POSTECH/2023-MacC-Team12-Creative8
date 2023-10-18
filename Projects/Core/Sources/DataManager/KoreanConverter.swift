//
//  KoreanConverter.swift
//  Core
//
//  Created by 고혜지 on 10/18/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

public final class KoreanConverter {
  static let shared = KoreanConverter()
  
  public func findKoreanName(artist: MusicBrainzArtist) -> (String, String?) {
    var primaryAlias: String?
    
    guard let aliases = artist.aliases else { return (artist.name!, nil) }
    
    if aliases.count == 1 {
      primaryAlias = aliases[0].name
      return (artist.name!, primaryAlias)
    }
    
    for alias in aliases {
      if (alias.primary == true) && (alias.name?.lowercased() != artist.name?.lowercased()) {
        primaryAlias = alias.name
        return (artist.name!, primaryAlias)
      } else if (alias.locale == "ko" || alias.locale == "ko_KR") {
        primaryAlias = alias.name
        return (artist.name!, primaryAlias)
      }
    }
    
    return (artist.name!, primaryAlias)
  }
  
  public func findKoreanTitle(title: String, songList: [(String, String?)]) -> String? {
    for song in songList {
      if title.lowercased() == song.0.lowercased() {
        return title
      } else if title.lowercased() == song.1?.lowercased() {
        return song.0
      }
    }
    return nil
  }
  
}

