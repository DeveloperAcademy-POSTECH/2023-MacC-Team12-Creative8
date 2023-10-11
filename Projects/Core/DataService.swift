//
//  DataService.swift
//  Core
//
//  Created by 고혜지 on 10/9/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import Foundation

enum Token: String {
    case setlitFM = "Etp_bKUUaREyYBjbLpdkritldxrwWRhrw48H"
    case musicBrainz = "API_KEY"
    case genius = "Bearer 7UINyw6MHKzr-CYFgeuL3ViZnpCLNvU1GeAo0ZKFEfyrvbyfSU5cWYMazDCXwIfh"
}

class DataService {
    static let shared = DataService()
    
    func searchArtistsFromMusicBrainz(artistName: String, completion: @escaping (ArtistListModel?) -> Void) {
        if let url = URL(string: "https://musicbrainz.org/ws/2/artist?query=\(artistName)&fmt=json") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(Token.musicBrainz.rawValue, forHTTPHeaderField: "Authorization")
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }
                
                if let JSONdata = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(ArtistListModel.self, from: JSONdata)
                        completion(decodedData)
                    } catch let error {
                        print(error)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    func fetchSetlistsFromSetlistFM(artistMbid: String, page: Int, completion: @escaping (SetlistListModel?) -> Void) {
        if let url = URL(string: "https://api.setlist.fm/rest/1.0/search/setlists?artistMbid=\(artistMbid)&p=\(page)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(Token.setlitFM.rawValue, forHTTPHeaderField: "x-api-key")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("en", forHTTPHeaderField: "Accept-Language")
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }
                
                if let JSONdata = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(SetlistListModel.self, from: JSONdata)
                        completion(decodedData)
                    } catch let error {
                        print(error)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
    
    func searchArtistFromGenius(artistName: String, completion: @escaping (GeniusArtistsModel?) -> Void) {
        if let url = URL(string: "https://api.genius.com/search?q=\(artistName)") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(Token.genius.rawValue, forHTTPHeaderField: "Authorization")
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }
                
                if let JSONdata = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(GeniusArtistsModel.self, from: JSONdata)
                        completion(decodedData)
                    } catch let error {
                        print(error)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }

    func fetchSongsFromGenius(artistId: Int, page: Int, completion: @escaping (GeniusSongsModel?) -> Void) {
        if let url = URL(string: "https://api.genius.com/artists/\(artistId)/songs?page=\(page)&per_page=50") {
            print("@LOG request url: \(url)")
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(Token.genius.rawValue, forHTTPHeaderField: "Authorization")
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }
                
                if let JSONdata = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(GeniusSongsModel.self, from: JSONdata)
                        completion(decodedData) // 데이터 성공적으로 파싱되면 completion 핸들러 호출
                    } catch let error {
                        print(error)
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
            task.resume()
        } else {
            completion(nil)
        }
    }
}
