//
//  SetlistViewModel.swift
//  Feature
//
//  Created by 고혜지 on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

// MARK: Core에 있는 class! 나중에 삭제할 예정!
class KoreanTitleConverter {
    static let shared = KoreanTitleConverter()
    
    func convertTitleToKorean(title: String, songList: [(String, String?)]) -> String? {
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
