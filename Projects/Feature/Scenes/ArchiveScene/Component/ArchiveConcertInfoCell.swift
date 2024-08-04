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
  @Binding var selectedTab: Tab
  let info: ArchivedConcertInfo
  let url: URL?
  let dataServiece = SetlistDataService()
  @StateObject var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    ZStack {
      imageBG
      VStack {
        menuBar
        Spacer()
        infoBlock
      }
      .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .onAppear { dataManager.modelContext = modelContext }
  }
  
  private var menuBar: some View {
    HStack {
      Spacer()
      Menu {
        NavigationLink(value: NavigationDelivery(artistInfo: SaveArtistInfo(name: info.artistInfo.name, country: "", alias: info.artistInfo.alias, mbid: info.artistInfo.mbid, gid: 0, imageUrl: "", songList: []))) {
          Text("아티스트 보기")
        }
        NavigationLink(value: NavigationDelivery(setlistId: info.setlist.setlistId, artistInfo: SaveArtistInfo(name: info.artistInfo.name, country: "", alias: info.artistInfo.alias, mbid: info.artistInfo.mbid, gid: 0, imageUrl: "", songList: []))) {
          Text("세트리스트 보기")
        }
        Button("공연 북마크 취소") { dataManager.deleteArchivedConcertInfo(info) }
      } label: {
        Image(systemName: "ellipsis")
          .font(.title3)
          .foregroundStyle(Color.mainBlack)
          .padding()
      }
    }
  }
  
  private var infoBlock: some View {
    VStack(alignment: .leading) {
      NavigationLink(value: NavigationDelivery(setlistId: info.setlist.setlistId, artistInfo: SaveArtistInfo(name: info.artistInfo.name, country: "", alias: "", mbid: info.artistInfo.mbid, gid: 0, imageUrl: "", songList: []))) {
        HStack {
          VStack(alignment: .leading) {
            Text(DateFormatter.dateFormatter().string(from: info.setlist.date))
              .padding(EdgeInsets(top: 3, leading: 7, bottom: 3, trailing: 7))
              .font(.caption)
              .fontWeight(.semibold)
              .foregroundStyle(Color.mainOrange)
              .background(Capsule().foregroundStyle(Color.orange100))
            Text(info.artistInfo.name)
              .font(.subheadline)
              .bold()
              .foregroundStyle(Color.mainBlack)
              .padding(.vertical, 8)
            Text(info.setlist.venue)
              .font(.footnote)
              .foregroundStyle(Color(UIColor.systemGray2))
          }
          .lineLimit(1)
          .padding(.vertical)
          Spacer()
        }
      }
      .padding(.horizontal, 10)
      .background(
        Rectangle()
          .frame(width: UIWidth*0.43)
          .foregroundStyle(Color.mainWhite)
      )
    }
  }
  
  @ViewBuilder
  private var imageBG: some View {
    Group {
      if let url = url {
        AsyncImage(url: url) { image in
          image
            .centerCropped()
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color(UIColor.systemGray3), lineWidth: 1)
//                .foregroundStyle(Color.clear)
            )
        } placeholder: {
          ProgressView()
        }
      } else {
        // TODO: 이미지 변경?
        if colorScheme == .light {
          Image(uiImage: UIImage(named: "whiteTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
            .centerCropped()
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color(UIColor.systemGray3), lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
            )
        } else {
          Image(uiImage: UIImage(named: "darkTicket", in: Bundle(identifier: "com.creative8.seta.UI"), compatibleWith: nil)!)
            .centerCropped()
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color(UIColor.systemGray3), lineWidth: 1) // 색상과 선 두께를 원하는 대로 설정
            )
        }
      }
    }
    .aspectRatio(1.0, contentMode: .fit)
    .clipShape(RoundedRectangle(cornerRadius: 12))
    
  }
}
