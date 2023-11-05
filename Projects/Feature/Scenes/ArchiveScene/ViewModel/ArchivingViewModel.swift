//
//  ArchivingViewModel.swift
//  Feature
//
//  Created by A_Mcflurry on 10/31/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import Foundation
import Core

class ArchivingViewModel: ObservableObject {
  static let shared = ArchivingViewModel()
	@Published var selectSegment: Bool = true
	@Published var selectArtist: String = ""
	@Published var artistSet: Set<String> = []

	func insertArtistSet(_ info: [ArchivedConcertInfo]) {
    if !artistSet.isEmpty { 
      artistSet.removeAll()
      if !info.contains(where: { $0.artistInfo.name == selectArtist }) {
        selectArtist = ""
      }
    }

		for index in 0..<info.count {
			artistSet.insert(info[index].artistInfo.name)
		}
	}
}
