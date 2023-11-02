//
//  ArchiveConcertInfoCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/30/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core

struct ArchiveConcertInfoCell: View {
	let info: ArchivedConcertInfo
	let dataServiece = SetlistDataService.shared
	@State var setlist: Setlist? = nil
	@State var isActiveSetlist: Bool = false
	@StateObject var dataManager = SwiftDataManager()
	@Environment(\.modelContext) var modelContext
	let yearFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy"
		return formatter
	}()

	let decimalFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "M.dd"
		return formatter
	}()

	var body: some View {
		HStack {
			VStack {
				Text(yearFormatter.string(from: info.setlist.date)).foregroundStyle(Color.fontGrey25)
				Text(decimalFormatter.string(from: info.setlist.date)).foregroundStyle(Color.mainBlack)
			}
			.font(.headline)

      Button {
        dataServiece.fetchOneSetlistFromSetlistFM(setlistId: info.setlist.setlistId, completion: { setlist in
              if let setlist = setlist {
                self.setlist = setlist
                isActiveSetlist.toggle()
              }})
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
				Button("세트리스트 보기") {
					dataServiece.fetchOneSetlistFromSetlistFM(setlistId: info.setlist.setlistId, completion: { setlist in
							  if let setlist = setlist {
								  self.setlist = setlist
								  isActiveSetlist.toggle()
							  }})
				}
				Button("공연 북마크 취소") { dataManager.deleteArchivedConcertInfo(info) }
			} label: {
				Image(systemName: "ellipsis")
					//.foregroundStyle(Color.fontBlack)
					.padding()
					.background(Color.clear)
			}
		}
		.navigationDestination(isPresented: $isActiveSetlist) {
			if let setlist = setlist {
				let artistInfo = ArtistInfo(name: info.artistInfo.name,
											alias: info.artistInfo.name,
											mbid: info.artistInfo.mbid,
											gid: info.artistInfo.gid,
											imageUrl: info.artistInfo.imageUrl,
											songList: info.artistInfo.songList)

				SetlistView(setlist: setlist, artistInfo: artistInfo)
			}
		}
		.onAppear { dataManager.modelContext = modelContext }
	}
}
