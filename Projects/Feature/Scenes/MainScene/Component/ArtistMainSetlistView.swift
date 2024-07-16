//
//  ArtistMainSetlistView.swift
//  Feature
//
//  Created by 최효원 on 7/16/24.
//  Copyright © 2024 com.creative8.seta. All rights reserved.
//

import SwiftUI
import Core

struct ArtistMainSetlistView: View {
  @State private var isSetlistExist = false
  @State private var isExpanded = false
  @StateObject var viewModel: MainViewModel
  let index: Int
  
  var body: some View {
    VStack {
      headerView
      Spacer().frame(height: 25)
      setlistContent
      footerView
    }
    .font(.footnote)
    .fontWeight(.semibold)
    .padding()
    .background(
      Rectangle()
        .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        .foregroundStyle(Color.backgroundWhite)
    )
    .padding(.horizontal)
    .frame(height: 1500, alignment: .top)
  }
  
  private var headerView: some View {
    HStack {
      Text("세트리스트")
      Spacer()
      Button {
        
      } label: {
        Image(systemName: "info.circle")
      }
      .opacity(isSetlistExist ? 1 : 0)
    }
    .foregroundStyle(Color.mainOrange)
    .padding(10)
    .background(
      RoundedRectangle(cornerRadius: 4)
        .foregroundStyle(Color.mainOrange).opacity(0.1)
    )
  }
  
  private var setlistContent: some View {
    let setlists: [Setlist?] = viewModel.setlists[index] ?? []
    
    guard let firstSetlist = setlists.first else {
      return AnyView(EmptyView())
    }
    
    let allSessions = firstSetlist?.sets?.setsSet ?? []
    let allSongs = allSessions.flatMap { $0.song ?? [] }
    
    let displaySongs: [Song]
    if isExpanded {
      displaySongs = allSongs
    } else {
      var tempSongs: [Song] = []
      for session in allSessions {
        for song in session.song ?? [] {
          if tempSongs.count < 3 {
            tempSongs.append(song)
          } else {
            break
          }
        }
        if tempSongs.count >= 3 {
          break
        }
      }
      displaySongs = tempSongs
    }
    
    return AnyView(
      VStack(alignment: .leading, spacing: 10) {
        ForEach(Array(displaySongs.enumerated()), id: \.offset) { index, song in
          if let title = song.name {
            Group {
              if song.tape == true {
                ListRowView(index: nil, title: title)
                  .opacity(0.6)
              } else {
                ListRowView(index: index + 1, title: title)
              }
            }
            .padding(.vertical, 7)
            
            if index + 1 < displaySongs.count {
              Divider()
            }
          }
        }
      }
        .padding(.horizontal, 10)
    )
  }
  
  private var footerView: some View {
    let setlists: [Setlist?] = viewModel.setlists[index] ?? []
    
    return HStack {
      Spacer()
      if setlists.count > 3 {
        Text(isExpanded ? "세트리스트 접기" : "세트리스트 전체 보기")
        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
      } else {
        Text("더보기에서 자세히 알아보기")
        Image(systemName: "chevron.right")
          .onTapGesture {
          }
      }
    }
    .onTapGesture {
      withAnimation {
        isExpanded.toggle()
      }
    }
    .foregroundStyle(Color.fontGrey2)
  }
  
  private struct ListRowView: View {
    var index: Int?
    var title: String
    
    var body: some View {
      HStack(alignment: .top, spacing: 16) {
        if let index = index {
          Text(String(format: "%02d", index))
            .foregroundStyle(Color.gray)
        } else {
          Image(systemName: "recordingtape")
            .foregroundStyle(Color.mainBlack)
        }
        
        Text(title)
          .foregroundStyle(Color.mainBlack)
          .lineLimit(1)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 10)
    }
  }
}
