//
//  ListView.swift
//  Feature
//
//  Created by 고혜지 on 11/7/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core

struct ListView: View {
  let setlist: Setlist?
  let artistInfo: ArtistInfo?
  @ObservedObject var vm: SetlistViewModel
  
  var body: some View {
    VStack {
      ForEach(setlist?.sets?.setsSet ?? [], id: \.name) { session in
        VStack(alignment: .leading) {
          if let sessionName = session.name {
            Text(sessionName)
              .font(.headline)
              .fontWeight(.bold)
              .foregroundStyle(Color.fontGrey25)
              .padding(.horizontal)
              .padding(.top, 30)
          }
          
          let songs = session.song ?? []
          ForEach(Array(songs.enumerated()), id: \.offset) { index, song in
            if let title = song.name {
              
              Group {
                if song.tape != nil && song.tape == true {
                  ListRowView(
                    index: nil,
                    title: vm.koreanConverter.findKoreanTitle(title: title, songList: artistInfo?.songList ?? []) ?? title,
                    info: song.info
                  )
                  .opacity(0.6)
                } else {
                  ListRowView(
                    index: index + 1,
                    title: vm.koreanConverter.findKoreanTitle(title: title, songList: artistInfo?.songList ?? []) ?? title,
                    info: song.info
                  )
                }
              }
              .padding(.horizontal)
              .padding(.vertical, 10)
              
              if index + 1 < songs.count {
                Divider()
              }
              
              // 애플 뮤직용 음악 배열
              if !vm.setlistSongName.contains(title) {
                let _ = vm.setlistSongName.append(title)
              }
              // 스크린샷용 음악 배열
              let tmp = vm.koreanConverter.findKoreanTitle(title: title, songList: artistInfo?.songList ?? []) ?? title
              if !vm.setlistSongKoreanName.contains(tmp) {
                let _ = vm.setlistSongKoreanName.append(tmp)
              }
              
            }
          }
        }
      }
    }
  }
}

private struct ListRowView: View {
  var index: Int?
  var title: String
  var info: String?
  
  var body: some View {
    HStack(alignment: .top, spacing: 20) {
      if let index = index {
        Text(String(format: "%02d", index))
          .foregroundStyle(Color.mainBlack)
      } else {
        Image(systemName: "recordingtape")
          .foregroundStyle(Color.mainBlack)
      }
      
      VStack(alignment: .leading, spacing: 10) {
        Text(title)
          .foregroundStyle(Color.mainBlack)
          .lineLimit(1)
        
        if let info = info {
          Text(info)
            .fontWeight(.regular)
            .foregroundStyle(Color.fontGrey25)
        }
      }
    }
    .font(.callout)
    .fontWeight(.semibold)
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

//#Preview {
//    ListView()
//}
