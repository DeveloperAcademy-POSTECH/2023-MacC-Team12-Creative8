//
//  KoreanNameConverter.swift
//  Core
//
//  Created by 고혜지 on 10/10/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

class KoreanNameConverter {
    static let shared = KoreanNameConverter()
    
    func findKoreanName(artist: MusicBrainzArtist) -> String {
        guard let aliases = artist.aliases else { return artist.name! }
        for alias in aliases {
            if (alias.locale == "ko" || alias.locale == "ko_KR") && (alias.type == "Artist name") {
                return alias.name! + "(" + artist.name! + ")"
            }
        }
        return artist.name!
    }

}
