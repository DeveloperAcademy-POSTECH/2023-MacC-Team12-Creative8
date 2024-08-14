//
//  AppleMusicService.swift
//  Core
//
//  Created by 최효원 on 10/18/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import MusicKit
import StoreKit
import Combine

public final class AppleMusicService: MusicPlaylistAddable, Sendable {
    public var id: MusicItemID = ""
    
    public init() {
    }
    
    actor SearchResultsManager {
        private var results: [(Int, MusicCatalogSearchResponse?)] = []

        func append(_ result: (Int, MusicCatalogSearchResponse?)) {
            results.append(result)
        }

        func getSortedResults() -> [(Int, MusicCatalogSearchResponse?)] {
            return results.sorted { $0.0 < $1.0 }
        }
    }

    public func addPlayList(name: String, musicList: [(String, String?)], venue: String?) {
        let searchResultsManager = SearchResultsManager()

        Task {
            // musicList를 index가 들어간 튜플로 변환
            let indexedMusicList = musicList.enumerated().map { (index, music) in
                (index, music)
            }

            // 모든 음악을 비동기로 검색
            await withTaskGroup(of: Void.self) { group in
                for (index, music) in indexedMusicList {
                    group.addTask {

                        do {
                            let response = try await self.searchMusic(title: music.0, singer: music.1 ?? "")
                                                        
                            // actor를 통해 안전하게 searchResults에 추가
                            await searchResultsManager.append((index, response))
                        } catch {
                            print("Error searching for '\(music.0)': \(error)")
                            
                            // 실패한 경우에도 인덱스를 유지
                            await searchResultsManager.append((index, nil))
                        }
                    }
                }
            }

            // 검색 결과를 인덱스 순서대로 정렬
            let sortedResults = await searchResultsManager.getSortedResults()

            // 유효한 곡만 필터링하여 배열로 변환
            let songsToAdd = sortedResults.compactMap { $0.1?.songs.first }

            // 플레이리스트 생성 및 곡 추가를 더 빠르게 처리
            let _ = try await MusicLibrary.shared.createPlaylist(
                name: name,
                description: "Seta에서 생성된 플레이리스트 입니다.",
                authorDisplayName: venue,
                items: songsToAdd
            )
        }
    }

    // MusicCatalogSearchRequest를 비동기로 처리하는 함수
    private func searchMusic(title: String, singer: String) async throws -> MusicCatalogSearchResponse {
        var request = MusicCatalogSearchRequest(term: "\(singer) \(title)", types: [MusicKit.Song.self])
        request.includeTopResults = true
        let response = try await request.response()
        return response
    }
    
    public func requestMusicAuthorization() {
        SKCloudServiceController.requestAuthorization { [weak self] status in
            switch status {
            case .authorized:
                print("Apple Music authorized")
            case .restricted:
                print("Apple Music authorization restricted")
            case .notDetermined:
                print("Apple Music authorization not determined")
            case .denied:
                print("Apple Music authorization denied")
            @unknown default:
                print("")
            }
        }
    }
    
}

public final class CheckAppleMusicSubscription: ObservableObject {
    @Published var check: Bool = false
    public static let shared: CheckAppleMusicSubscription = CheckAppleMusicSubscription()
    // 사용자가 애플 뮤직을 구독 중인지 확인
    public init() {
    }
    
    public func appleMusicSubscription(completion: @escaping (Bool) -> Void) {
        SKCloudServiceController().requestCapabilities { (capability: SKCloudServiceCapability, err: Error?) in
            guard err == nil else { return }
            if capability.contains(SKCloudServiceCapability.musicCatalogPlayback) {
                self.check = true
            } else if capability.contains(SKCloudServiceCapability.musicCatalogSubscriptionEligible) {
                self.check = false
            }
            completion(self.check)
        }
    }
}
