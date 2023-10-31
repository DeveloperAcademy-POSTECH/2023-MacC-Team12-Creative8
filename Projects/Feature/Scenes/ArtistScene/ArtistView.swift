//
//  ArtistView.swift
//  Feature
//
//  Created by 고혜지 on 10/21/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

private let screenWidth = UIScreen.main.bounds.width
private let screenHeight = UIScreen.main.bounds.height

struct ArtistView: View {
  let artistName: String
  let artistAlias: String?
  let artistMbid: String
  
  @StateObject var vm = ArtistViewModel()
  
  var body: some View {
    VStack {
      if vm.isLoading1 || vm.isLoading2 {
        ProgressView()
      } else {
        ScrollView {
          ArtistImageView(vm: vm)
          BookmarkedView(vm: vm)
          ListView(vm: vm)
        }
      }
    }
    .navigationTitle("")
    .toolbar {
      ToolbarItem(placement: .principal) {
          VStack {
            Text(vm.artistInfo?.name ?? "")
              .font(.system(size: 19))
              .fontWeight(.semibold)
          }
          .fontWeight(.semibold)
      }
    }
    .foregroundStyle(Color.fontBlack)
    .onAppear {
      vm.getArtistInfoFromGenius(artistName: artistName, artistAlias: artistAlias, artistMbid: artistMbid)
      vm.getSetlistsFromSetlistFM(artistMbid: artistMbid)
    }
  }
}

private struct ArtistImageView: View {
  @ObservedObject var vm: ArtistViewModel
  @Query var concertInfo: [ArchivedConcertInfo]
  @StateObject var dataManager = SwiftDataManager()
  @Environment(\.modelContext) var modelContext
  var body: some View {
    ZStack(alignment: .bottom) {
      if vm.image != nil {
        imageLayer
      } else {
        ProgressView()
      }
      HStack {
        textLayer
        Spacer()
        buttonLayer
      }
      .padding()
    }
    .padding()
    .onAppear {
      vm.loadImage()
      dataManager.modelContext = modelContext
    }
  }
  
  private var imageLayer: some View {
    Image(uiImage: vm.image!)
      .centerCropped()
      .frame(height: screenHeight * 0.25)
      .cornerRadius(14)
      .overlay(Color.black.opacity(0.2).cornerRadius(14))
  }

  private var textLayer: some View {
    Text(vm.artistInfo?.name ?? "")
      .font(.system(size: 36))
      .fontWeight(.semibold)
      .foregroundStyle(Color.fontWhite)
  }

  private var buttonLayer: some View {
    Button {
      dataManager.addLikeArtist(
        name: vm.artistInfo?.name ?? "",
        country: "",
        alias: vm.artistInfo?.alias ?? "",
        mbid: vm.artistInfo?.mbid ?? "",
        gid: vm.artistInfo?.gid ?? 0,
        imageUrl: vm.artistInfo?.imageUrl ?? "",
        songList: vm.artistInfo?.songList ?? [])
    } label: {
      Circle()
        .frame(width: screenWidth * 0.1)
        .foregroundStyle(Color.mainWhite1)
        .overlay(
          Image(systemName: "heart.fill")
            .foregroundStyle(Color.mainWhite)
        )
    }
  }
  
}

private struct BookmarkedView: View {
  @ObservedObject var vm: ArtistViewModel
  
  var body: some View {
    VStack {
      titleLayer
        .padding()
      
      if vm.showBookmarkedSetlists {
        ZStack {
          RoundedRectangle(cornerRadius: 15)
            .foregroundStyle(Color.mainGrey1)
          
          if vm.bookmarkedSetlists == nil {
            emptyLayer
          } else {
            setlistsLayer
            .padding(.horizontal)
          }
        }
        .padding()
        .frame(height: screenHeight * 0.35)
        
      }
    }
  }
  
  private var titleLayer: some View {
    HStack {
      Text("공연 다시 듣기")
        .font(.system(size: 20))
        .fontWeight(.bold)
      Spacer()
      Button {
        vm.showBookmarkedSetlists.toggle()
      } label: {
        Image(systemName: vm.showBookmarkedSetlists ? "chevron.down" : "chevron.right")
      }
      .foregroundStyle(Color.fontBlack)
    }
  }
  
  private var emptyLayer: some View {
    VStack(alignment: .center, spacing: 5) {
      Text("다시 듣기한 공연이 없습니다.")
        .font(.system(size: 16))
        .fontWeight(.semibold)
        .padding(.bottom)
        .foregroundStyle(Color.fontBlack)
      Group {
        Text("다시 듣기할 공연을 눌러 표시해주세요.")
        Text("아카이빙에서도 볼 수 있어요.")
      }
      .font(.system(size: 13))
      .foregroundStyle(Color.fontGrey2)
    }
  }
  
  private var setlistsLayer: some View {
    VStack {
      Spacer()
      ForEach(vm.bookmarkedSetlists?.prefix(3) ?? [], id: \.id) { setlist in
        NavigationLink {
          
        } label: {
          HStack {
            Spacer()
            
            Text(vm.getFormattedDate(date: setlist.eventDate ?? "") ?? "")
              .font(.system(size: 17))
              .fontWeight(.semibold)
            
            Spacer()
            
            VStack(spacing: 5) {
              Text(setlist.tour?.name ?? "")
                .fontWeight(.semibold)
              let venue = "\(setlist.venue?.name ?? ""), \(setlist.venue?.city?.name ?? ""), \(setlist.venue?.city?.country?.name ?? "")"
              Text(venue)
            }
            .font(.system(size: 14))
            .frame(width: screenWidth * 0.65, height: 33)
            .padding(.vertical)
            
            Spacer()
          }
          .foregroundStyle(Color.fontBlack)
        }

        Divider()
          .foregroundStyle(Color.fontGrey3)
          .padding(.horizontal)

      }
      
      NavigationLink {
        
      } label: {
        HStack {
          Spacer()
          Text("\(vm.artistInfo?.name ?? "") 아카이빙에서 보기")
          Image(systemName: "arrow.right")
        }
        .font(.system(size: 14))
        .foregroundStyle(Color.fontBlack)
      }
      
      Spacer()
    }
  }
  
}

private struct ListView: View {
  @ObservedObject var vm: ArtistViewModel
  
  var body: some View {
    VStack {
      titleLayer
        .padding()
      setlistsLayer
      if vm.page != vm.totalPage {
        buttonLayer
      }
    }
  }
  
  private var titleLayer: some View {
    HStack {
      Text("전체 공연 보기")
        .font(.system(size: 20))
        .fontWeight(.bold)
        .foregroundStyle(Color.fontBlack)
      Spacer()
    }
  }
  
  private var setlistsLayer: some View {
    ForEach(vm.setlists ?? [], id: \.id) { setlist in
      NavigationLink {
        SetlistView(setlist: setlist, artistInfo: vm.artistInfo)
      } label: {
        HStack {
          Spacer()
          
          Text(vm.getFormattedDate(date: setlist.eventDate ?? "") ?? "")
            .font(.system(size: 17))
            .fontWeight(.semibold)
          
          Spacer()
          
          VStack(spacing: 5) {
            Text(setlist.tour?.name ?? "")
              .fontWeight(.semibold)
            let venue = "\(setlist.venue?.name ?? ""), \(setlist.venue?.city?.name ?? ""), \(setlist.venue?.city?.country?.name ?? "")"
            Text(venue)
          }
          .font(.system(size: 14))
          .frame(width: screenWidth * 0.65, height: 33)
          .padding(.vertical)
          
          Spacer()
        }
        .foregroundStyle(Color.fontBlack)
        .opacity(vm.isEmptySetlist(setlist) ? 0.2 : 1.0)
      }

      Divider()
        .foregroundColor(Color.lineGrey1)
        .padding(.horizontal)

    }
  }
  
  private var buttonLayer: some View {
    VStack {
      Button {
        vm.fetchNextPage(artistMbid: vm.artistInfo?.mbid ?? "")
      } label: {
        if vm.isLoading3 {
          ProgressView()
            .padding()
        } else {
          Text("더보기")
            .font(.system(size: 14))
            .fontWeight(.bold)
            .foregroundStyle(Color.fontBlack)
            .padding()
        }
      }
      
      Divider()
        .foregroundStyle(Color.lineGrey1)
        .padding(.horizontal)
    }
  }
  
}

#Preview {
  ArtistView(artistName: "IU", artistAlias: "아이유", artistMbid: "b9545342-1e6d-4dae-84ac-013374ad8d7c")
}
