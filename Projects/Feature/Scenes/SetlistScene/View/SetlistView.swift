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
  @StateObject var exportViewModel = ExportPlaylistViewModel()
  
  var body: some View {
    ZStack {
      Color.gray6
      ScrollView(showsIndicators: false) {
        VStack {
          SetlistInfoView(
            imageUrl: artistInfo.imageUrl,
            title: setlist?.tour?.name ?? (vm.isKorean() ? "\(artistInfo.name)의 세트리스트" : "\(artistInfo.name)'s playlist"),
            artistName: artistInfo.name,
            venue: setlist?.venue?.name ?? "-",
            location: "\(setlist?.venue?.city?.name ?? "-"), \(setlist?.venue?.city?.country?.name ?? "-")",
            date: vm.allDateFormatter(inputDate: setlist?.eventDate ?? "") ?? "-",
            artistInfo: artistInfo,
            setlist: setlist,
            viewModel: vm,
            bookmarkButtonAction: {
              if vm.isBookmarked {
                vm.dataManager.findConcertAndDelete(concertInfo, setlist?.id ?? "")
                showToastMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                  showToastMessage = false
                }
              } else {
                saveData()
              }
              vm.isBookmarked.toggle()
            },
            isBookmarkedSetlist: vm.isBookmarked
          )
          .padding(.top, 10)
          .padding(.bottom, -40)
        
          if let setlist = setlist {
            if vm.isEmptySetlist(setlist) {
              EmptySetlistView()
                .padding(UIWidth * 0.1)
                .padding(.top, 100)
            } else {
              ListView(setlist: setlist, artistInfo: artistInfo, vm: vm)
                .padding(UIWidth * 0.1)
                .padding(.bottom, 150)
            }
          }
        }
      }
      if let setlist = setlist {
        if !vm.isEmptySetlist(setlist) {
          ExportPlaylistButtonView(setlist: setlist,
                                   artistInfo: artistInfo,
                                   vm: vm,
                                   showToastMessageAppleMusic: $exportViewModel.showToastMessageAppleMusic,
                                   showToastMessageCapture: $exportViewModel.showToastMessageCapture,
                                   showToastMessageSubscription: $exportViewModel.showToastMessageSubscription,
                                   showSpotifyAlert: $exportViewModel.showSpotifyAlert,
                                   showCaptureAlert: $exportViewModel.showCaptureAlert,
                                   exportViewModel: exportViewModel)
        }
      }
      if showToastMessage {
        VStack {
          ToastMessageView(
            message: vm.isBookmarked ? "보관함‑북마크한 공연에 담겼어요." : "보관이 취소되었어요!", subMessage: nil,
            icon: vm.isBookmarked ? "checkmark.circle.fill" : "checkmark.circle.badge.xmark.fill",
            color: vm.isBookmarked ? Color.toast1 : Color.toast2
          )
          .padding(.horizontal, UIWidth * 0.075)
          .padding(.top, 5)
          Spacer()
        }
      }
    }
    .customAlert(primaryButton: CustomAlertButton(title: "확인", action: {
      let musicList = vm.setlistSongName
      exportViewModel.addToAppleMusic(musicList: musicList, setlist: setlist)
    }), dismissButton: CustomAlertButton(title: "취소", action: {
      vm.showModal.toggle()
      exportViewModel.showAppleMusicAlert.toggle()
    }),
                 isPresented: $exportViewModel.showAppleMusicAlert,
                 artistInfo: artistInfo,
                 setlist: setlist,
                 exportViewModel: exportViewModel
    )
    .toolbar(.hidden, for: .tabBar)
    .navigationTitle("세트리스트")
    .navigationBarTitleDisplayMode(.inline)
    .background(Color.mainWhite)
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
  
  private func saveData() {
    let newArtist = SaveArtistInfo(
      name: artistInfo.name,
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

extension View {
  func customAlert( primaryButton: CustomAlertButton, dismissButton: CustomAlertButton,
                    isPresented: Binding<Bool>,
                    artistInfo: ArtistInfo,
                    setlist: Setlist?,
                    exportViewModel: ExportPlaylistViewModel
  ) -> some View {
    return modifier(CustomAlertModifier(dismissButton: dismissButton,
                                        primaryButton: primaryButton,
                                        isPresented: isPresented,
                                        artistInfo: artistInfo,
                                        setlist: setlist,
                                        exportViewModel: exportViewModel
                                       )
    )
    
  }
}
