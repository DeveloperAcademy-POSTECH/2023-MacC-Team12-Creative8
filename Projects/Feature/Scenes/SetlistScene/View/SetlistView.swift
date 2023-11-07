//
//  SetlistView.swift
//  Feature
//
//  Created by 고혜지 on 11/1/23.
//  Copyright © 2023 com.creative8.seta. All rights reserved.
//

import SwiftUI
import SwiftData
import Core
import UI

struct SetlistView: View {
  @State var setlist: Setlist?
  var setlistId: String?
  @State var artistInfo: ArtistInfo
  
  @StateObject var vm = SetlistViewModel()
  @Query var concertInfo: [ArchivedConcertInfo]
  @Query var likeArtist: [LikeArtist]
  @Environment(\.modelContext) var modelContext
  @State private var showToastMessage = false
  
  var body: some View {
    ZStack {
      Color.backgroundWhite
      ScrollView(showsIndicators: false) {
        VStack(spacing: -1) {
          concertInfoArea
          dotLine
          setlistArea
        }
        .background(Color.mainBlack)
        .toolbar { ToolbarItem(placement: .topBarTrailing) { toolbarBookmarkButton } }
      }
      if let setlist = setlist {
        if !vm.isEmptySetlist(setlist) {
          ExportPlaylistButtonView(setlist: setlist, artistInfo: artistInfo, vm: vm)
        }
      }
      if showToastMessage {
        VStack {
          ToastMessageView(message: "북마크한 공연이 추가되었습니다.")
            .padding(.leading, 80)
            .padding(.trailing, 20)
          Spacer()
        }
      }
    }
    .toolbar(.hidden, for: .tabBar)
    .background(Color.backgroundWhite)
    .edgesIgnoringSafeArea(.bottom)
    .onAppear {
      if setlistId != nil {
        vm.isLoading = true
        vm.dataService.fetchOneSetlistFromSetlistFM(setlistId: setlistId!) { result in
          if let result = result {
            DispatchQueue.main.async {
              self.setlist = result
              vm.dataManager.modelContext = modelContext
              vm.isBookmarked = vm.dataManager.isAddedConcert(concertInfo, setlist?.id ?? "")
              vm.isLoading = false
            }
          }
        }
      } else {
        vm.dataManager.modelContext = modelContext
        vm.isBookmarked = vm.dataManager.isAddedConcert(concertInfo, setlist?.id ?? "")
      }
      
      if artistInfo.songList == nil || artistInfo.songList?.isEmpty == true {
        vm.artistDataManager.getArtistInfo(artistInfo: artistInfo) { result in
          if let result = result {
            artistInfo = result
            for artist in likeArtist {
              if artist.artistInfo.mbid == artistInfo.mbid {
                vm.dataManager.updateLikeArtistInfo(artist, artistInfo.imageUrl ?? "", artistInfo.songList ?? [])
              }
            }
          }
        }
      }
    }
    
  }
  
  private var concertInfoArea: some View {
    ZStack {
      Rectangle()
        .cornerRadius(14, corners: [.bottomLeft, .bottomRight])
        .foregroundStyle(Color.backgroundWhite)
        .ignoresSafeArea()
      ConcertInfoView(
        artist: artistInfo.name,
        date: vm.getFormattedDateFromString(date: setlist?.eventDate ?? "", format: "yyyy년 MM월 dd일") ?? "-",
        venue: setlist?.venue?.name ?? "-",
        tour: setlist?.tour?.name ?? "-"
      )
      .padding([.horizontal, .bottom], 30)
      .padding(.vertical, 15)
    }
  }
  
  private var dotLine: some View {
    Rectangle()
      .stroke(style: StrokeStyle(dash: [5]))
      .frame(height: 1)
      .padding(.horizontal)
      .foregroundStyle(Color.fontGrey2)
  }
  
  private var setlistArea: some View {
    ZStack {
      Rectangle()
        .cornerRadius(14, corners: [.topLeft, .topRight])
        .foregroundStyle(Color.backgroundWhite)
        .ignoresSafeArea()
      if let setlist = setlist {
        if vm.isEmptySetlist(setlist) {
          EmptySetlistView()
            .padding(30)
        } else {
          VStack {
            ListView(setlist: setlist, artistInfo: artistInfo, vm: vm)
              .padding(30)
            BottomView()
          }
        }
      }
    }
  }
  
  private var toolbarBookmarkButton: some View {
    Button(action: {
      if vm.isBookmarked {
        vm.dataManager.findConcertAndDelete(concertInfo, setlist?.id ?? "")
      } else {
        saveData()
      }
      vm.isBookmarked.toggle()
    }, label: {
      Image(systemName: vm.isBookmarked ? "bookmark.fill" : "bookmark")
        .foregroundStyle(Color.mainBlack)
    })
  }
  
  private func saveData() {
    let newArtist = SaveArtistInfo(
      name: setlist?.artist?.name ?? "",
      country: setlist?.venue?.city?.country?.name ?? "",
      alias: artistInfo.alias ?? "",
      mbid: artistInfo.mbid,
      gid: artistInfo.gid ?? 0,
      imageUrl: artistInfo.imageUrl ?? "",
      songList: artistInfo.songList ?? [])
    let newSetlist = SaveSetlist(
      setlistId: setlist?.id ?? "",
      date: vm.convertDateStringToDate(setlist?.eventDate ?? "") ?? Date(),
      venue: setlist?.venue?.name ?? "",
      title: setlist?.tour?.name ?? "",
      city: setlist?.venue?.city?.name ?? "",
      country: setlist?.venue?.city?.country?.name ?? "")
    
    vm.dataManager.addArchivedConcertInfo(newArtist, newSetlist)
    showToastMessage = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      showToastMessage = false
    }
  }
}
