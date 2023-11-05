//
//  ArchiveConcertInfoCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/30/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core
import UI

struct ArchiveConcertInfoCell: View {
	let info: ArchivedConcertInfo
	let dataServiece = SetlistDataService.shared
	@StateObject var dataManager = SwiftDataManager()
	@Environment(\.modelContext) var modelContext

	var body: some View {
		HStack {
			VStack {
        Text(DateFormatter.yearFormatter().string(from: info.setlist.date)).foregroundStyle(Color.fontGrey25)
				Text(DateFormatter.dateMonthFormatter().string(from: info.setlist.date)).foregroundStyle(Color.mainBlack)
			}
			.font(.headline)

      NavigationLink {
        SetlistView(setlistId: info.setlist.setlistId, artistInfo: ArtistInfo(name: info.artistInfo.name, mbid: info.artistInfo.mbid))
      } label: {
        VStack(alignment: .leading) {
          Text(info.artistInfo.name).font(.subheadline).foregroundStyle(Color.mainBlack)
          Text(info.setlist.venue).font(.footnote).foregroundStyle(Color.mainBlack)
        }
      }
			.padding(.leading)

			Spacer()

			Menu {
				NavigationLink("아티스트 보기") { ArtistView(artistName: info.artistInfo.name, artistAlias: info.artistInfo.alias, artistMbid: info.artistInfo.mbid) }
				NavigationLink("세트리스트 보기") {
          SetlistView(setlistId: info.setlist.setlistId, artistInfo: ArtistInfo(name: info.artistInfo.name, mbid: info.artistInfo.mbid))
				}
				Button("공연 북마크 취소") { dataManager.deleteArchivedConcertInfo(info) }
			} label: {
				Image(systemName: "ellipsis")
					.foregroundStyle(Color.mainBlack)
					.padding()
					.background(Color.clear)
			}
		}
		.onAppear { dataManager.modelContext = modelContext }
	}
}
