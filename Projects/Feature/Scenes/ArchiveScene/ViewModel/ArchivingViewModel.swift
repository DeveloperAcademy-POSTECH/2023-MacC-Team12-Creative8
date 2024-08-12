//
//  ArchivingViewModel.swift
//  Feature
//
//  Created by A_Mcflurry on 10/31/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import Core
import Combine
import SwiftUI

class ArchivingViewModel: ObservableObject {
  
//  // MARK: Tab View
//  @Published var pageStack: [NavigationDelivery] = []
//  
//  private var subscription: AnyCancellable?
//  
//  init(consecutiveTaps: AnyPublisher<Void, Never>) {
//    subscription = consecutiveTaps
//      .sink { [weak self] in
//        guard let self else { return }
//        
//        withAnimation {
//          if self.pageStack.isEmpty {
//            // Scroll 최상단으로 이동
//          } else {
//            self.pageStack.removeLast()
//          }
//        }
//        
//      }
//  }
  
  static let shared = ArchivingViewModel()
  @Published var selectSegment: SelectEnum = .bookmark
	@Published var selectArtist: String = ""
	@Published var artistSet: Set<ArchivedConcertInfo> = []

	func insertArtistSet(_ info: [ArchivedConcertInfo]) {
    if !artistSet.isEmpty { 
      artistSet.removeAll()
      if !info.contains(where: { $0.artistInfo.name == selectArtist }) {
        selectArtist = ""
      }
    }
      
      // 임시 딕셔너리를 사용하여 아티스트 MBID별로 가장 최근 정보를 저장
      var uniqueArtists: [String: ArchivedConcertInfo] = [:]

      for concert in info {
          let artistMBID = concert.artistInfo.mbid
          // 이미 존재하는 MBID라면, 더 최신 정보로 업데이트 (또는 다른 기준 적용)
          if let existingConcert = uniqueArtists[artistMBID] {
              // 여기에 더 최신 정보를 선택하는 로직을 추가할 수 있습니다.
              // 예를 들어, 날짜를 비교하거나 다른 기준을 사용할 수 있습니다.
              uniqueArtists[artistMBID] = concert
          } else {
              uniqueArtists[artistMBID] = concert
          }
      }

      // 중복이 제거된 아티스트 정보를 Set에 삽입
      artistSet = Set(uniqueArtists.values)

//		for index in 0..<info.count {
//			artistSet.insert(info[index])
//		}
	}

  enum SelectEnum {
    case bookmark
    case likeArtist
  }
}
