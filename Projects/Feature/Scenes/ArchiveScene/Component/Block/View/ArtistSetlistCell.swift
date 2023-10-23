//
//  ArtistSetlistCell.swift
//  Feature
//
//  Created by A_Mcflurry on 10/23/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core

struct ArtistSetlistCell: View {
  let info: ArchivedConcertInfo
  let isDetail: Bool

  let dataServiece = SetlistDataService.shared
  @StateObject var viewModel = ArchiveViewModel()
  @StateObject var dataManager = SwiftDataManager()
  @ObservedObject var setlistVm = SetlistViewModel()
  @Environment(\.modelContext) var modelContext
  var body: some View {
    let formattedDate = viewModel.dateFormatter.string(from: info.setlist.date)
    let dayOfWeek = viewModel.dayOfWeekFormatter.string(from: info.setlist.date)
    let artistInfo = ArtistInfo(name: info.artistInfo.name,
                                alias: info.artistInfo.name,
                                mbid: info.artistInfo.mbid,
                                gid: info.artistInfo.gid,
                                imageUrl: info.artistInfo.imageUrl,
                                songList: dataManager.songListDecoder(info.artistInfo.songList))
    HStack {
      Button {
        dataServiece.fetchOneSetlistFromSetlistFM(setlistId: info.setlist.setlistId, completion: { setlist in
          if let setlist = setlist {
            viewModel.setlist = setlist
            viewModel.isActiveButton.toggle()
          }
        })
      } label: {
        HStack {
          VStack(spacing: 5) {
            Text(formattedDate)
              .foregroundStyle(.black)
              .font(.callout)
              .bold()
            Text(dayOfWeek)
              .foregroundStyle(.gray)
              .font(.callout)
          }

          VStack(alignment: .leading) {
            Text(info.artistInfo.name).bold()
            Text(info.setlist.title).bold()
            Text(info.setlist.venue)
          }
          .foregroundStyle(.black)
          .font(.system(size: 14))
          .padding(.leading)
        }
      }
      .navigationDestination(isPresented: $viewModel.isActiveButton) {
        if let setlist = viewModel.setlist {
          SetlistView(setlist: setlist,
                      artistInfo: artistInfo)
        }
      }
      Spacer()

      if isDetail {
        Menu {
          NavigationLink("아티스트로 가기") {  }
          Button("해당 공연 삭제") { dataManager.deleteArchivedConcertInfo(info) }
        } label: {
          Image(systemName: "ellipsis")
            .rotationEffect(.degrees(90))
            .padding()
            .background(Color.clear)
        }
      }
    }
    .onAppear { dataManager.modelContext = modelContext }
    .padding()
  }
}
