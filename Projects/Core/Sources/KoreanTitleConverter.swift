//
//  KoreanTitleConverter.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

class KoreanTitleConverter {
    static let shared = KoreanTitleConverter()
    
    let dataService: DataService = DataService.shared
    
    func findKoreanTitle(title: String, songList: [(String, String?)]) -> String? {
        for song in songList {
            if title.lowercased() == song.0.lowercased() {
                return title
            } else if title.lowercased() == song.1?.lowercased() {
                return song.0
            }
        }
        return nil
    }
    
    func getSongListByArtist(artistName: String, completion: @escaping ([(String, String?)]?) -> Void) {
        var parsedSongList: [(String, String?)] = []
        var artistId: Int?
        var songList: [String] = []
        
        dataService.searchArtistFromGenius(artistName: artistName) { result in
            if let result = result {
                DispatchQueue.main.async {
                    artistId = self.findArtistId(artistName: artistName, hits: result.response?.hits ?? [])
                    
                    self.fetchAllSongs(artistId: artistId ?? 0) { result in
                        if let result = result {
                            songList = result
                            for song in songList {
                                parsedSongList.append(
                                    (self.extractTextBeforeParentheses(from: song),
                                     self.extractTextInsideFirstParentheses(from: song))
                                )
                            }
                            completion(parsedSongList)
                        } else {
                            completion(nil)
                        }
                    }
                    
                }
            } else {
                completion(nil)
            }
        }
    }
    
    private func fetchAllSongs(artistId: Int, completion: @escaping ([String]?) -> Void) {
        var songList: [String] = []
        
        func fetchPage(page: Int) {
            dataService.fetchSongsFromGenius(artistId: artistId, page: page) { result in
                guard let result = result, let songs = result.response?.songs else {
                    completion(nil)
                    return
                }
                for song in songs {
                    songList.append(song.title ?? "")
                }
                if let nextPage = result.response?.nextPage {
                    fetchPage(page: nextPage)
                } else {
                    completion(songList)
                }
            }
        }
        
        fetchPage(page: 1)
    }
    
    private func findArtistId(artistName: String, hits: [Hit]) -> Int? {
        for hit in hits {
            let name = hit.result?.primaryArtist?.name ?? ""
            if removeFirstParentheses(from: name) == artistName {
                return hit.result?.primaryArtist?.id
            }
        }
        return nil
    }
    
    private func extractTextBeforeParentheses(from input: String) -> String {
        if let range = input.range(of: "(") {
            let textBeforeParentheses = input[..<range.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
            return String(textBeforeParentheses)
        } else {
            return input
        }
    }
    
    private func extractTextInsideFirstParentheses(from input: String) -> String? {
        if let startIndex = input.firstIndex(of: "("), let endIndex = input.firstIndex(of: ")"), startIndex < endIndex {
            let range = (input.index(after: startIndex)..<endIndex)
            let textInsideParentheses = input[range].trimmingCharacters(in: .whitespacesAndNewlines)
            return String(textInsideParentheses)
        } else {
            return nil
        }
    }
    
    private func removeFirstParentheses(from input: String) -> String {
        if let startIndex = input.firstIndex(of: "("), let endIndex = input.firstIndex(of: ")"), startIndex < endIndex {
            let firstParenthesesRange = startIndex...endIndex
            let modifiedString = input.replacingCharacters(in: firstParenthesesRange, with: "")
            return modifiedString.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            return input
        }
    }

}
