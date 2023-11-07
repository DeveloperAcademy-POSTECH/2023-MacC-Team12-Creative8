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
  
  // MARK: 온보딩에서 Genius ID 찾을 때 사용할 함수
  public func getGeniusIdAndImageUrl(mbid: String, completion: @escaping ((Int, String)?) -> Void) {
    let dataService = SetlistDataService.shared
    let koreanConverter = KoreanConverter.shared
    let artistDataManager = ArtistDataManager.shared

    dataService.fetchArtistFromMusicBrainz(artistMbid: mbid) { result in
      if let result = result {
        let namePair = koreanConverter.findKoreanName(artist: (result.artists?[0])!)
        var artistInfo = ArtistInfo(name: namePair.0, mbid: mbid)

        artistDataManager.getArtistInfo(artistInfo: artistInfo) { result in
          if let result = result {
            DispatchQueue.main.async {
              artistInfo = result
              completion((artistInfo.gid, artistInfo.imageUrl) as? (Int, String))
            }
          } else {
            artistDataManager.getArtistInfo(artistInfo: artistInfo) { result in
              if let result = result {
                DispatchQueue.main.async {
                  artistInfo = result
                  completion((artistInfo.gid, artistInfo.imageUrl) as? (Int, String))
                }
              } else {
                completion(nil)
              }
            }
          }
        }
      }
    }
  }
  
  public func getArtistInfo(artistInfo: ArtistInfo, completion: @escaping (ArtistInfo?) -> Void) {
    var parsedSongList: [Titles] = []
    var newArtistInfo: ArtistInfo = artistInfo
    var songList: [String] = []
    
    dataService.searchArtistFromGenius(artistName: newArtistInfo.name ) { result in
      if let result = result {
        DispatchQueue.main.async {
          newArtistInfo = self.findArtistIdAndImage(artistInfo: newArtistInfo, hits: result.response?.hits ?? [])
          
          self.fetchAllSongs(artistId: newArtistInfo.gid ?? 0) { result in
            if let result = result {
              songList = result
              for song in songList {
                parsedSongList.append(Titles(title: self.extractTextBeforeParentheses(from: song), subTitle: self.extractTextInsideFirstParentheses(from: song) ?? ""))
              }
              newArtistInfo.songList = parsedSongList
              completion(newArtistInfo)
            } else {
              completion(newArtistInfo)
            }
          }
          completion(newArtistInfo)
          
        }
      } else {
        completion(newArtistInfo)
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
  
  private func findArtistIdAndImage(artistInfo: ArtistInfo, hits: [Hit]) -> ArtistInfo {
    for hit in hits {
      if let name = hit.result?.primaryArtist?.name {
        let filteredName = stringFilter(name)
        let filteredArtistName = stringFilter(artistInfo.name)
        let filteredArtistAlias = stringFilter(artistInfo.alias ?? "")
        
        if removeFirstParentheses(from: filteredName) == filteredArtistName ||
            extractTextInsideFirstParentheses(from: filteredName) == filteredArtistName ||
            removeFirstParentheses(from: filteredName) == filteredArtistAlias ||
            extractTextInsideFirstParentheses(from: filteredName) == filteredArtistAlias {
          print("FIND ARTIST: \(name)")
          return ArtistInfo(
            name: artistInfo.name,
            alias: artistInfo.alias,
            mbid: artistInfo.mbid,
            gid: hit.result?.primaryArtist?.id,
            imageUrl: hit.result?.primaryArtist?.imageURL,
            songList: nil
          )
        }
      }
    }
    
    print("FAILED TO FIND ARTIST")
    return artistInfo
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
