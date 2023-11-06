//
//  ArtistDataManager.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

public final class ArtistDataManager {
  public static let shared = ArtistDataManager()
  
  let dataService: SetlistDataService = SetlistDataService.shared
  
  public func getArtistInfo(artistName: String, artistAlias: String, artistMbid: String, completion: @escaping (ArtistInfo?) -> Void) {
    var parsedSongList: [Titles] = []
    var artistInfo: ArtistInfo?
    var songList: [String] = []
    
    dataService.searchArtistFromGenius(artistName: artistName) { result in
      if let result = result {
        DispatchQueue.main.async {
          artistInfo = self.findArtistIdAndImage(artistName: artistName, artistAlias: artistAlias, artistMbid: artistMbid, hits: result.response?.hits ?? [])
          
          self.fetchAllSongs(artistId: artistInfo?.gid ?? 0) { result in
            if let result = result {
              songList = result
              for song in songList {
                parsedSongList.append(Titles(title: self.extractTextBeforeParentheses(from: song), subTitle: self.extractTextInsideFirstParentheses(from: song) ?? ""))
              }
              artistInfo?.songList = parsedSongList
              completion(artistInfo)
            } else {
              completion(nil)
            }
          }
          completion(artistInfo)
          
        }
      } else {
        completion(nil)
      }
    }
  }
  
  public func getArtistImageURL(artistName: String, artistMbid: String) {
    var artistInfo: ArtistInfo?
    
    dataService.searchArtistFromGenius(artistName: artistName) { result in
      if let result = result {
        DispatchQueue.main.async {
          artistInfo = self.findArtistIdAndImage(artistName: artistName, artistAlias: "", artistMbid: artistMbid, hits: result.response?.hits ?? [])
        }
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
  
  private func findArtistIdAndImage(artistName: String, artistAlias: String, artistMbid: String, hits: [Hit]) -> ArtistInfo? {
    for hit in hits {
      if let name = hit.result?.primaryArtist?.name {
        let filteredName = stringFilter(name)
        let filteredArtistName = stringFilter(artistName)
        let filteredArtistAlias = stringFilter(artistAlias)
        
        if removeFirstParentheses(from: filteredName) == filteredArtistName ||
            extractTextInsideFirstParentheses(from: filteredName) == filteredArtistName ||
            removeFirstParentheses(from: filteredName) == filteredArtistAlias ||
            extractTextInsideFirstParentheses(from: filteredName) == filteredArtistAlias {
          print("FIND ARTIST: \(name)")
          return ArtistInfo(name: artistName, alias: artistAlias, mbid: artistMbid, gid: hit.result?.primaryArtist?.id, imageUrl: hit.result?.primaryArtist?.imageURL, songList: nil)
        }
      }
    }
    print("FAILED TO FIND ARTIST")
    return nil
  }
  
  private func stringFilter(_ str: String) -> String {
    return str
      .trimmingCharacters(in: .whitespaces)
      .replacingOccurrences(of: " ", with: "")
      .filter { $0.unicodeScalars.first?.value != 8203 }
  }
  
  // 첫 번째 괄호 이전의 텍스트를 추출
  private func extractTextBeforeParentheses(from input: String) -> String {
    if let range = input.range(of: "(") {
      let textBeforeParentheses = input[..<range.lowerBound].trimmingCharacters(in: .whitespacesAndNewlines)
      return String(textBeforeParentheses)
    } else {
      return input
    }
  }
  
  // 첫 번째 괄호 사이의 텍스트를 추출
  private func extractTextInsideFirstParentheses(from input: String) -> String? {
    if let startIndex = input.firstIndex(of: "("), let endIndex = input.firstIndex(of: ")"), startIndex < endIndex {
      let range = (input.index(after: startIndex)..<endIndex)
      let textInsideParentheses = input[range].trimmingCharacters(in: .whitespacesAndNewlines)
      return String(textInsideParentheses)
    } else {
      return nil
    }
  }
  
  //  첫 번째 괄호를 제거
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
