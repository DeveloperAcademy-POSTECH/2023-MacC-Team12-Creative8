//
//  ArchivingView.swift
//  Feature
//
//  Created by A_Mcflurry on 10/14/23.
//  Copyright © 2023 com.creative8. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

struct ArchivingView: View {
	@Query var likeArtist: [LikeArtist]
	@Query(sort: \ArchivedConcertInfo.setlist.date, order: .reverse) var concertInfo: [ArchivedConcertInfo]
	@StateObject var viewModel = ArchivingViewModel()

	var body: some View {
		ScrollView {
			VStack {
				Divider()
				segmentedButtonsView
				archiveListView
			}
			.padding()
		}
		.navigationTitle("보관함")
	}

	private var segmentedButtonsView: some View {
		HStack {
			Button("북마크한 공연") {
				viewModel.selectSegment = true
			}
			.foregroundStyle(viewModel.selectSegment ? Color.fontBlack : Color.fontGrey3)

			Button("찜한 아티스트") {
				viewModel.selectSegment = false
			}
			.foregroundStyle(viewModel.selectSegment ? Color.fontGrey3 : Color.fontBlack)
			.padding(.horizontal)
		}
		.font(.headline)
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.vertical)
	}

	private var archiveListView: some View {
		Group {
			if viewModel.selectSegment {
				bookmarkListView
			} else {
				allArtistView
			}
		}
	}

	private var bookmarkListView: some View {
		VStack {
			ScrollView(.horizontal) {
				HStack {
					ForEach(viewModel.artistSet.sorted(), id: \.self) { artist in
						Button {
              if let index = viewModel.selectArtist.firstIndex(of: artist) {
                  viewModel.selectArtist.remove(at: index)
              } else {
                  viewModel.selectArtist.insert(artist, at: 0)
              }
						} label: {
							ArtistSetCell(name: artist, isSelected: viewModel.selectArtist.contains(artist))
						}
					}
				}
			}
			ForEach(concertInfo) { item in
        if viewModel.selectArtist.isEmpty || viewModel.selectArtist.contains(item.artistInfo.name) {
          ArchiveConcertInfoCell(info: item)
            .padding()
          Divider()
        }
			}
		}
		.onAppear { viewModel.insertArtistSet(concertInfo) }
	}

  private var allArtistView: some View {
    ForEach(likeArtist) { item in
      HStack {
        ArchiveArtistCell(artistUrl: URL(string: item.artistInfo.imageUrl)!, isNewUpdate: false)
        Text("\(item.artistInfo.name)")
          .foregroundStyle(Color.fontBlack)
        Spacer()
        MenuButton(item: item)
      }
    }
  }
}

#Preview {
	NavigationStack {
		ArchivingView()
	}
}

struct MenuButton: View {
  let item: LikeArtist
  @StateObject var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  var body: some View {
    Menu {
      NavigationLink("아티스트로 가기") { ArtistView(artistName: item.artistInfo.name, artistAlias: item.artistInfo.alias, artistMbid: item.artistInfo.mbid) }
      Button("좋아요 취소") { dataManager.deleteLikeArtist(item) }
    } label: {
      Image(systemName: "ellipsis")
        .foregroundStyle(Color.fontBlack)
        .rotationEffect(.degrees(-90))
        .padding(.horizontal)
        .background(Color.clear)
    }
    .onAppear { dataManager.modelContext = modelContext }
  }
}
